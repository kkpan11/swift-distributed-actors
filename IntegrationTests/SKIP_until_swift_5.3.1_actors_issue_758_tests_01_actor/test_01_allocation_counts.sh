#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the Swift Distributed Actors open source project
##
## Copyright (c) 2018-2019 Apple Inc. and the Swift Distributed Actors project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

source defines.sh

set -eu
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

all_tests=()
for file in "$here/test_01_resources/"test_*.swift; do
    test_name=$(basename "$file")
    test_name=${test_name#test_*}
    test_name=${test_name%*.swift}
    all_tests+=( "$test_name" )
done

"$here/test_01_resources/run-alloc-counter-tests.sh" -t "$tmp" > "$tmp/output"

for test in "${all_tests[@]}"; do
    cat "$tmp/output"  # helps debugging
    total_allocations=$(grep "^test_$test.total_allocations:" "$tmp/output" | cut -d: -f2 | sed 's/ //g')
    not_freed_allocations=$(grep "^test_$test.remaining_allocations:" "$tmp/output" | cut -d: -f2 | sed 's/ //g')
    max_allowed_env_name="MAX_ALLOCS_ALLOWED_$test"

    info "$test: allocations not freed: $not_freed_allocations"
    info "$test: total number of mallocs: $total_allocations"

    assert_less_than "$not_freed_allocations" 5     # allow some slack
    assert_greater_than "$not_freed_allocations" -5 # allow some slack
    if [[ -z "${!max_allowed_env_name+x}" ]]; then
        if [[ -z "${!max_allowed_env_name+x}" ]]; then
            warn "no reference number of allocations set (set to \$$max_allowed_env_name)"
            warn "to set current number:"
            warn "    export $max_allowed_env_name=$total_allocations"
        fi
    else
        max_allowed=${!max_allowed_env_name}
        assert_less_than_or_equal "$total_allocations" "$max_allowed"
        assert_greater_than "$total_allocations" "$(( max_allowed - 1000))"
    fi
done
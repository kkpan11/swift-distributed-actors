//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@testable import DistributedActors
import Logging
import NIO

// usual reminder that Swift Distributed Actors is not inherently "client/server" once associated, only the handshake is
enum HandshakeSide: String {
    case client
    case server
}

extension ClusterShellState {
    static func makeTestMock(side: HandshakeSide, configureSettings: (inout ClusterSettings) -> Void = { _ in () }) -> ClusterShellState {
        var settings = ClusterSettings(
            node: Node(
                systemName: "MockSystem",
                host: "127.0.0.1",
                port: 7337
            )
        )
        configureSettings(&settings)
        let log = Logger(label: "handshake-\(side)") // TODO: could be a mock logger we can assert on?

        return ClusterShellState(
            settings: settings,
            channel: EmbeddedChannel(),
            events: EventStream(ref: ActorRef(.deadLetters(.init(log, address: ._deadLetters, system: nil)))),
            gossipControl: ConvergentGossipControl(ActorRef(.deadLetters(.init(log, address: ._deadLetters, system: nil)))),
            log: log
        )
    }
}
// ==== ------------------------------------------------------------------ ====
// === DO NOT EDIT: Generated by GenActors                     
// ==== ------------------------------------------------------------------ ====

import DistributedActors

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated TestActorable messages 

extension TestActorable {
    public enum Message { 
    case ping 
    case greet(name: String) 
    case greetUnderscoreParam(String) 
    case greet2(name: String, surname: String)  
    }
}

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated TestActorable behavior

extension TestActorable {
    public static func makeBehavior(context: ActorContext<Message>) -> Behavior<Message> {
        return .setup { context in
            var instance = Self(context: context) // TODO: has to become some "make"            

            // /* await */ self.instance.preStart(context: context) // TODO: enable preStart

            return .receiveMessage { message in
                switch message { 
                
                case .ping:
                    instance.ping() 
                case .greet(let name):
                    instance.greet(name: name) 
                case .greetUnderscoreParam(let name):
                    instance.greetUnderscoreParam(name) 
                case .greet2(let name, let surname):
                    instance.greet2(name: name, surname: surname) 
                }
                return .same
            }
        }
    }

}

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: Extend Actor for TestActorable

// TODO: could this be ActorRef?
extension Actor where Myself.Message == TestActorable.Message {
    
    public func ping() { // TODO: returning things
        self.ref.tell(.ping)
    } 
    
    public func greet(name: String) { // TODO: returning things
        self.ref.tell(.greet(name: name))
    } 
    
    public func greetUnderscoreParam(_ name: String) { // TODO: returning things
        self.ref.tell(.greetUnderscoreParam(name))
    } 
    
    public func greet2(name: String, surname: String) { // TODO: returning things
        self.ref.tell(.greet2(name: name, surname: surname))
    }

    
}
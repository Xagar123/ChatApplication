//
//  Service.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import Firebase

struct Service {
    
    static func fetchUsers(completion: @escaping([User])-> Void) {
        
        var users = [User]()
        COLLECTION_USER.getDocuments { snapShot, error in
            
            guard var users = snapShot?.documents.map({ User(dictionary: $0.data()) }) else {return}
            
            if let i = users.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid }) {
                users.remove(at: i)
            }
            completion(users)
        }
    }
    
    static func featchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USER.document(uid).getDocument { snapShot, error in
            guard let dictionary = snapShot?.data() else { return}
            let user = User(dictionary: dictionary)
            completion(user)
                    
        }
    }
    
   static func uploadMessage(_ message: String, to User: User, completion:((Error?)-> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return}
        
        let data: [String: Any] = ["text": message,
                    "fromId": currentUid,
                    "toId": User.uid,
                    "timeStamp": Timestamp(date: Date()) ]
        
        COLLECTION_MESSAGES.document(currentUid).collection(User.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(User.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentUid).collection("recent-message").document(User.uid).setData(data)
            
            COLLECTION_MESSAGES.document(User.uid).collection("recent-message").document(currentUid).setData(data)
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message])-> Void) {
        var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timeStamp")
        
        query.addSnapshotListener { snapShot, error in
            snapShot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchConversation(competion: @escaping([Conversation])-> Void) {
    
        var conversion = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-message").order(by: "timeStamp")
        
        query.addSnapshotListener { snapShot, error in
            snapShot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.featchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversion.append(conversation)
                    competion(conversion)
                }
               
            })
        }
    }
}

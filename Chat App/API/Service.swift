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
        Firestore.firestore().collection("USER").getDocuments { snapShot, error in
            snapShot?.documents.forEach({ document in
                let dictionary = document.data()
                
                let user = User(dictionary: dictionary)
                
                users.append(user)
                completion(users)
                print("DEBUG User name: \(user.userName)")
                print("DEBUG Full name: \(user.fullName)")
            })
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
}

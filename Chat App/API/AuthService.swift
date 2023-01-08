//
//  AuthService.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import UIKit
import Firebase

struct RegistrationCredential {
    let email:String
    let password: String
    let fullName: String
    let userName: String
    let profileImage : UIImage
}


struct AuthService {
    
    static let shared = AuthService()
    
    
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credential: RegistrationCredential, completion: ((Error?)-> Void)?) {
        
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                print("DEBUG: fail to upload image \(error.localizedDescription)")
                completion!(error)
                return
            }
            
            ref.downloadURL( completion: { (url, error) in
                
                guard let imageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion!(error)
                        return
                    }
                    guard let uid = result?.user.uid else {return}
                    
                    let data = ["email": credential.email,
                                "fullname": credential.fullName,
                                "profileImage": imageUrl,
                                "uid": uid,
                                "username": credential.userName] as [String: Any]
                    
                    Firestore.firestore().collection("USER").document(uid).setData(data, completion: completion)
                    

                }
            })
            
        }
    }
}

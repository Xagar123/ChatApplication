//
//  User.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import UIKit

struct User {
    let uid:String
    let profileImageUrl: String
    let userName:String
    let fullName:String
    let email:String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImage"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
    
}

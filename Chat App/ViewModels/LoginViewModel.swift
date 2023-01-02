//
//  LoginViewModel.swift
//  Chat App
//
//  Created by Admin on 01/01/23.
//

import Foundation

struct LoginViewModel {
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
        && fullName?.isEmpty == false
        && userName?.isEmpty == false
    }
}

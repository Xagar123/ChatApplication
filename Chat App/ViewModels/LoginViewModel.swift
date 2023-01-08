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
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
        
    }
}

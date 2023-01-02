//
//  RegistrationViewModel.swift
//  Chat App
//
//  Created by Admin on 02/01/23.
//

import Foundation

struct RegistrationViewModel {
    
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

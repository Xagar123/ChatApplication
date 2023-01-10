//
//  ProfileViewModel.swift
//  Chat App
//
//  Created by Admin on 10/01/23.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo 
    case setting
    
    var discription: String {
        switch self {
            
        case .accountInfo:
            return "Account Info"
        case .setting:
            return "Setting"
        }
    }
    
    var iconImageName: String {
        switch self {
            
        case .accountInfo:
            return "person.circle"
        case .setting:
            return "gear"
        }
    }
    
    
}

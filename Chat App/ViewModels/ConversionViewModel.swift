//
//  ConversionViewModel.swift
//  Chat App
//
//  Created by Admin on 09/01/23.
//

import Foundation

struct ConversionViewModel {
    
    private let conversion: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversion.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversion.message.timeStamp.dateValue()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "hh:mm a"
        return dateFormater.string(from: date)
    }
    init(conversion: Conversation) {
        self.conversion = conversion
    }
}

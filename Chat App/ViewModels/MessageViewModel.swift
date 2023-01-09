//
//  MessageViewModel.swift
//  Chat App
//
//  Created by Admin on 09/01/23.
//

import UIKit

struct MessageViewMode {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .systemPurple
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAncorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAncorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else {return nil}
        return URL(string: user.profileImageUrl)
    }
    init(message: Message) {
        self.message = message
    }
}

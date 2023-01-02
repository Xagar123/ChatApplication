//
//  CustomeTextField.swift
//  Chat App
//
//  Created by Admin on 01/01/23.
//

import UIKit

class CustomeTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [.foregroundColor: UIColor.white])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

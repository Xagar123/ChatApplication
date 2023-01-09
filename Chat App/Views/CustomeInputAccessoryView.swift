//
//  CustomeInputAccessoryView.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import UIKit

protocol CustomeInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CustomeInputAccessoryView, wantsToSend message: String)
}

class CustomeInputAccessoryView: UIView {
    
    weak var delegate: CustomeInputAccessoryViewDelegate?
    
    //MARK: -Properties
    lazy var messageInputTextView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
        
    }()
    
    private let placeholderLable: UILabel = {
        let lable = UILabel()
        lable.text = "Enter Message"
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textColor = .lightGray
        return lable
    }()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
       addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor,paddingTop: 12, paddingLeft: 4,paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeholderLable)
        placeholderLable.anchor(left: messageInputTextView.leftAnchor,paddingLeft: 4)
        placeholderLable.centerY(inView: messageInputTextView)
        
        //hiding and displaying placeholder
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Selector
    
    @objc func handleSendMessage() {
        guard let text = messageInputTextView.text else { return}
        delegate?.inputView(self, wantsToSend: text)
    }
    
    @objc func handleTextInputChange() {
        placeholderLable.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    //MARK: -Helper
    
    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLable.isHidden = false
        
    }
}

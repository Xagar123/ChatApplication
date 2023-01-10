//
//  ChatController.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import UIKit

private let reuseIdentifier = "messageCell"
class ChatController: UICollectionViewController {
    
    //MARK: -Properties
    
    private let user: User
    
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customeInputView: CustomeInputAccessoryView = {
        let iv = CustomeInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //MARK: -Lifecycle
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
        
    }
    
    override var inputAccessoryView: UIView? {
        get { return customeInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: -API
    
    func fetchMessages() {
        Service.fetchMessages(forUser: user) { messages in
            self.messages = messages
            self.collectionView.reloadData()
            
            //scroll down to bottom when new message send
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    //MARK: -Selector
    
    
    
    //MARK: -Helper
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.userName, preferLargeTitle: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

//defining custome cell sizing
extension ChatController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

extension ChatController: CustomeInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CustomeInputAccessoryView, wantsToSend message: String) {
        
        
        
//        fromCurrentUser.toggle()
//        let message = Message(text: message, isFromCurrentUser: fromCurrentUser)
//        messages.append(message)
//        collectionView.reloadData()
        Service.uploadMessage(message, to: user) { error in
            if let error = error {
                print("DEBUG failed to upload message \(error.localizedDescription)")
                return
            }
            
            inputView.clearMessageText()
        }
    }
    
    
}


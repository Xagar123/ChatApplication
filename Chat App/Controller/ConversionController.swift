//
//  ConversionController.swift
//  Chat App
//
//  Created by Admin on 31/12/22.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversionCell"

class ConversionController: UIViewController {
    
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    
    private var conversation = [Conversation]()
    private var conversationDictionary = [String: Conversation]()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for:.normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        authenticateUser()
        fetchConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", preferLargeTitle: true)
    }
    
    
    //MARK: - API
    
    func fetchConversation() {
        showLoader(true,withText: "Loading")
        Service.fetchConversation { conversation in
            
            conversation.forEach { conversation in
                let message = conversation.message
                self.conversationDictionary[message.chatPartnerId] = conversation
            }
            self.showLoader(false)
            self.conversation = Array(self.conversationDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG User is not loged in present login screen")
            presentLoginScreen()
        }else {
            print("DEBUG: User is logged in. configure controller \(Auth.auth().currentUser?.uid)")
            
        }
    }
   
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG : Error signout")
        }
    }
    //MARK: - Helper
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureUI() {

        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
        
    }
    
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView() //it will return no. of cell which register
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Selector
    
    @objc func showProfile() {
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}

extension ConversionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversation[indexPath.row].user
        showChatController(forUser: user)
    }
    
}

extension ConversionController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! ConversationCell
       // cell.textLabel?.text = conversation[indexPath.row].message.text
        print("Before assining")
        cell.conversation = conversation[indexPath.row]
        print("after assonong")
        return cell
    }
}

//MARK: -NewMessageControllerDelegate

extension ConversionController: NewMessageControllerDelegate {
    
    func controller(_ controller: NewMessageController, wantToStartChatWith user: User) {
        dismiss(animated: true,completion: nil)
        showChatController(forUser: user)
    }

}

//MARK: -ProfileControllerDelegate
extension ConversionController: ProfileControllerDelegate {
    
    func handleLogout() {
        logout()
    }
}

//MARK: - AuthenticationDelegate

extension ConversionController: AuthenticationDelegate {
    
    func authenticationComplete() {
        self.dismiss(animated: true)
        configureUI()
        fetchConversation()
    }
    
    
}

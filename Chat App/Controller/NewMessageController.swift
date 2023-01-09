//
//  NewMessageController.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantToStartChatWith user: User)
}

class NewMessageController: UITableViewController {
    
    //MARK: -Properties
    
    private var users = [User]()
    weak var delegate: NewMessageControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    //MARK: -API
    
    func fetchUser() {
        Service.fetchUsers { user in
            self.users = user
            self.tableView.reloadData()
            print("DEBUG user in new message \(user)")
        }
    }
    
    //MARK: -Selector
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Helper
    
    func configureUI() {
        configureNavigationBar(withTitle: "New Message", preferLargeTitle: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
}

//MARK: - UITableviewDataSource

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantToStartChatWith: users[indexPath.row])
    }
}

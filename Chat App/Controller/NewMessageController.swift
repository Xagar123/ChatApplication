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
    private var filterUsers = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //help to identify user is searching or not
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
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
    
    func configureSearchController() {
        
        //search functionaliity
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false // it will not give dark backgroung
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        
        
        //changing textField color
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.backgroundColor = .clear
        }
        
    }
}

//MARK: - UITableviewDataSource

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterUsers.count : users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! UserCell
        cell.user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantToStartChatWith: user)
    }
}


extension NewMessageController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //filter method
        guard let searchText = searchController.searchBar.text?.lowercased() else { return}
        
        print("DEBUG Search query is \(searchText)")
        filterUsers = users.filter({ user -> Bool in
            return user.userName.contains(searchText) || user.fullName.contains(searchText)
            
        })
        self.tableView.reloadData()
        print("DEBUG Filtered User \(filterUsers)")
        
    }
    
    
}

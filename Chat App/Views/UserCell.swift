//
//  UserCell.swift
//  Chat App
//
//  Created by Admin on 08/01/23.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    var user: User? {
        didSet { configure() }
    }
    
    //MARK: -Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemPurple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        
        return iv
    }()
    
    private let usernameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 14)
     //   lable.text = "Sam"
        return lable
    }()
    
    private let fullnameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = .lightGray
     //   lable.text = "hello"
        return lable
    }()
    
    
    //MARK: -Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 56, width: 56)
        profileImageView.layer.cornerRadius = 56 / 2
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLable, fullnameLable])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    
    func configure() {
        guard let user = user else {return}
        fullnameLable.text = user.fullName
        usernameLable.text = user.userName
        
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
}

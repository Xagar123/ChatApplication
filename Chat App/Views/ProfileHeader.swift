//
//  ProfileHeader.swift
//  Chat App
//
//  Created by Admin on 09/01/23.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func dismissController()
}

class ProfileHeader: UIView {
    
    //MARK: -Properties
    
    var user: User? {
        didSet{ populateUserData() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        lable.textColor = .white
        lable.textAlignment = .center
     //   lable.text = "test full name"
        return lable
    }()
    
    private let usernameLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textAlignment = .center
      //  lable.text = "test username "
        return lable
    }()
    //MARK: -Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  configureGradientLayer()
        backgroundColor = .systemPink
        configureUI()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper
    
    func populateUserData() {
        guard let user = user else { return}
        fullnameLable.text = user.fullName
        usernameLable.text = "@" + user.userName
        
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
    
    func configureUI() {
//        backgroundColor = .clear
//        configureGradientLayer()
        
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLable,usernameLable])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44,paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    

    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0,1]
        layer.addSublayer(gradient)
        
        gradient.frame = frame
    }
    
    
    //MARK: -Selector
    
    @objc func handleDismissal() {
        delegate?.dismissController()
    }
}

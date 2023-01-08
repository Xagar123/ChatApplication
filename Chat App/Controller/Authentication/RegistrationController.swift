//
//  RegistrationController.swift
//  Chat App
//
//  Created by Admin on 01/01/23.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationController: UIViewController {
    
    
    //MARK: -Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        let containerView = InputContainerView(image:UIImage(systemName: "envelope"), textField: emailTextField)
        containerView.backgroundColor = .clear
        
        return containerView
    }()
    
    private lazy var fullNameContainerView: InputContainerView = {
        let containerView = InputContainerView(image:UIImage(systemName: "person"), textField: fullNameTextField)
        containerView.backgroundColor = .clear
        
        return containerView
    }()
    
    private lazy var userNameContainerView: InputContainerView = {
        let containerView = InputContainerView(image:UIImage(systemName: "person"), textField: userNameTextField)
        containerView.backgroundColor = .clear
        
        return containerView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
        return containerView
    }()
    
    private let emailTextField = CustomeTextField(placeholder: "Email")
    private let fullNameTextField = CustomeTextField(placeholder: "Full Name")
    private let userNameTextField = CustomeTextField(placeholder: "User Name")
     
     private let passwordTextField: CustomeTextField = {
         let tf = CustomeTextField(placeholder: "Password")
         tf.isSecureTextEntry = true
         return tf
     }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        
        
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor.white])
        attributeTitle.append(NSAttributedString(string: "Login", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    
    //MARK: - Helper
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            
        }else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureUI() {
        configureGradientLayer()
        configureNotificationObservers()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,fullNameContainerView,userNameContainerView,passwordContainerView,signupButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 16)
        
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - Selector
    
    @objc func handleSelectPhoto() {
        print("Selected photo inside")
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
                
        present(picker, animated: true)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let userName = userNameTextField.text?.lowercased() else {return}
        guard let profileImage = profileImage else {return}
        
        let credential = RegistrationCredential(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        
        showLoader(true, withText: "Singing you up")
        
        AuthService.shared.createUser(credential: credential) { error in
            if let error = error {
                print("DEBUG fail to login with USER \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func textDidChnage(sender: UITextField) {
        print("text field change \(sender.text)")
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        }
        checkFormStatus()
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("image picker delegate")
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
        print("inside imagepicker")
    }
    
    
}

//MARK: - AuthenticationControllerProtocol

//extension RegistrationController: Authen

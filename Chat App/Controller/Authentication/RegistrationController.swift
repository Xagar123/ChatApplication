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
    private var viewModel = LoginViewModel()
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
        
        emailTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChnage), for: .editingChanged)
    }
    
    
    //MARK: - Selector
    
    @objc func handleSelectPhoto() {
        print("Selected photo inside")
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
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            ref.downloadUrl { (url, error) in
                guard let profileImageUrl = url.absoluteURL else {return}

                Auth.auth().currentUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let uid = result?.user.uid else {return}

                    let data = ["email": email,
                                "fullname": fullName,
                                "profileImage": profileImageUrl,
                                "uid": uid,
                                "username": userName] as [String: Any]
                    Firestore.firestore().collection("USER").document(uid).setData(data) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        print("user created")
                    }
               }

       }
        
//        ref.putData(imageData) { metaData, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            ref.downloadUrl { (url, error) in
//                guard let profileImageUrl = url.absoluteURL else {return}
//
//                Auth.auth().currentUser(withEmail: email, password: password) { (result, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//                    guard let uid = result?.user.uid else {return}
//
//                    let data = ["email": email,
//                                "fullname": fullName,
//                                "profileImage": profileImageUrl,
//                                "uid": uid,
//                                "username": userName] as [String: Any]
//                    Firestore.firestore().collection("USER").document(uid).setData(data) { error in
//                        if let error = error {
//                            print(error.localizedDescription)
//                            return
//                        }
//                        print("user created")
//                    }
//                }
//            }

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
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200/2
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - AuthenticationControllerProtocol

//extension RegistrationController: Authenticati

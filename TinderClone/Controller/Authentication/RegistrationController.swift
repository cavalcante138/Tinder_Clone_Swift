//
//  RegistrationController.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 17/03/22.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController{
    
    // Mark - Properties
    
    private var viewModel = RegistrationViewModel()
    weak var delegate: AuthenticationDelegate?
    private var profileImage: UIImage?
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let img = UIImage(named: "plus_photo")
        
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let fullNameTextField = CustomTextField(placeholder: "Full Name", capitalizationType: .sentences)
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()
    
    private let goToLoginButton: UIButton = {
       
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handelShowLogin), for: .touchUpInside)
        
        return button
        
        
    }()
    
    // Mark - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFieldObservers()
        configureUI()
    }
    
    //Mark - Actions
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            viewModel.password = sender.text
        } else{
            viewModel.fullname = sender.text
        }
        
        checkFormStatus()
        
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid{
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        } else{
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        }
    }
    
    @objc func handleSelectPhoto(){
        let picker  = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleRegisterUser(
    ){
        
        guard let email = emailTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let profileImage = self.profileImage else {
            return
        }

        
        let credetials = AuthCredentials(email: email, password: password, fullname: fullName, profileImage: profileImage)
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        
        AuthService.registerUser(withCredentias: credetials, completion: {
            error in
            if let error = error{
                print("Debug: Error signing user up \(error.localizedDescription)")
              
                        hud.dismiss()
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    
            }
        hud.dismiss()
        self.delegate?.authenticationComplete()
          
        })
    }
    
    @objc func handelShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //Mark - Helpers
    
    func configureUI() {
        configureGradientLayer()
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        
        let stack = UIStackView(arrangedSubviews: [ emailTextField, fullNameTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
    }
    
    func configureTextFieldObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }

    
}

// Mark: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
}

//
//  RegistrationController.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit
import JGProgressHUD

class UploadImageController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private let profilePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Upload New", for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    
    
    private let emailTextField = CustomTextField(placeholder: "ImageName + @ImageBin.Live")
    private let fullNameTextField = CustomTextField(placeholder: "Image description")
    private let passwordTextField = CustomTextField(placeholder: " re-Enter Password",
                                                    hiddenField: true)
    private var profilePicture: UIImage?
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    
    
    }()
    

        
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFieldObserver()
        congfigureUi()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }

    
    
    // MARK: - Actions
    
    @objc func handleSelectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
            
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
        
    }
    
    @objc func handleRegisterUser() {
        guard let email = emailTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let profilePicture = profilePicture else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image..."
        hud.show(in: view)
        
        let credentials = AuthCredentials(email: email
                                          , fullName: fullName, password: password,
                                          profilePicture: profilePicture)
        
        AuthService.registerUser(withCredentials: credentials) { error in
            hud.dismiss()
            if let error = error {
                print("DEBUG: Error signing user up \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            hud.dismiss()
            self.delegate?.authenticationComplete()
        
        }
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullname = sender.text
            } else {
                viewModel.password = sender.text
    
            }
        //print("DEBUG: Form is valid \(viewModel.formIsValid)")
        checkFormStatus()
        
}
    
    // MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
    }
    
    
    func congfigureUi() {
        configureGradientLayer()
        
        view.addSubview(profilePhotoButton)
        profilePhotoButton.setDimensions(height: 250, width: 250)
        profilePhotoButton.centerX(inView: view)
        profilePhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        
        
        
        let stack = UIStackView(arrangedSubviews: [fullNameTextField,emailTextField,
                                                   passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: profilePhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        
        
        
    }
    
    func configureTextFieldObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    

}

    // MARK: - UIImagePickerControllerDelegate

extension UploadImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profilePicture = image
        profilePhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        profilePhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        profilePhotoButton.layer.borderWidth = 3
        profilePhotoButton.setDimensions(height: 160, width: 160)
        profilePhotoButton.layer.cornerRadius = 80
        profilePhotoButton.clipsToBounds = true
        profilePhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
}
    







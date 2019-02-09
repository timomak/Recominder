//
//  LoginViewController.swift
//  Recaminder
//
//  Created by timofey makhlay on 2/8/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    // To check if logging in or signing up
    var isLoggingIn = true
    
    // Textfield for email
    private let emailTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "email"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 25)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .center
        textField.tag = 0
        return textField
    }()
    
    // Email view
    private var emailViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 25
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // Textfield for password
    private let passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "password"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 25)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .center
        textField.tag = 1
        return textField
    }()
    
    // password view
    private var passwordViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 25
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // Textfield for confirm password
    private let confirmPasswordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "confirm password"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 25)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .center
        textField.tag = 2
        return textField
    }()
    
    // password view
    private var confirmPasswordViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 25
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // Continue button
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 30)
        button.backgroundColor = #colorLiteral(red: 0.9599618316, green: 0.275388211, blue: 0.4092237353, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()

    // Register button
    private let logInOrSignUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register?", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8250355721, green: 0.7137643695, blue: 0.7113270164, alpha: 1)
        
        // Adding extension to simplify typing
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Programmatically adding parameters
        loadLogIn()
    }
    
    func loadLogIn() {
        // Email
        view.addSubview(emailViewContainer)
        view.addSubview(emailTextField)
        emailTextField.delegate = self
        
        // Password
        view.addSubview(passwordViewContainer)
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        
        // Register Button
        view.addSubview(logInOrSignUpButton)
        
        // Continue Button
        view.addSubview(continueButton)
        
        
        // Email constrains
        emailViewContainer.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 250, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 50))
        emailTextField.anchor(top: emailViewContainer.topAnchor, leading: emailViewContainer.leadingAnchor, bottom: emailViewContainer.bottomAnchor, trailing: emailViewContainer.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        
        // Password constrains
        passwordViewContainer.anchor(top: emailViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: emailViewContainer.bounds.height + 30, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 50))
        
        passwordViewContainer.centerHorizontalOfView(to: emailViewContainer)
        passwordTextField.anchor(top: passwordViewContainer.topAnchor, leading: passwordViewContainer.leadingAnchor, bottom: passwordViewContainer.bottomAnchor, trailing: passwordViewContainer.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        // Register constraints
        logInOrSignUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        // Continue constrains
        continueButton.anchor(top: emailViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 200, left: 50, bottom: 0, right: 50))
    }
    
    // Changing between Sign in and Log in
    @objc func registerButtonPressed() {
        if isLoggingIn == true {
            logInOrSignUpButton.setTitle("Login?", for: .normal)
            isLoggingIn = false
            
            // Adding password confirmation for signup
            view.addSubview(confirmPasswordViewContainer)
            view.addSubview(confirmPasswordTextField)
            
            // Password confirmation constrains
            confirmPasswordViewContainer.anchor(top: passwordViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 50))
            
            confirmPasswordViewContainer.centerHorizontalOfView(to: emailViewContainer)
            confirmPasswordTextField.anchor(top: confirmPasswordViewContainer.topAnchor, leading: confirmPasswordViewContainer.leadingAnchor, bottom: confirmPasswordViewContainer.bottomAnchor, trailing: confirmPasswordViewContainer.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
            
        }
        else if isLoggingIn == false {
            logInOrSignUpButton.setTitle("Register?", for: .normal)
            isLoggingIn = true
            
            // Removing password confirmation
            confirmPasswordViewContainer.removeFromSuperview()
            confirmPasswordTextField.removeFromSuperview()
        }
    }
    
    private func incorrectPassword() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: confirmPasswordViewContainer.center.x - 10, y: confirmPasswordViewContainer.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: confirmPasswordViewContainer.center.x + 10, y: confirmPasswordViewContainer.center.y))
        
        confirmPasswordViewContainer.layer.add(animation, forKey: "position")
    }
    
    @objc func continueButtonPressed() {
        print("Continue pressed")
        incorrectPassword()
    }
    
    let networkManager = NetworkManager()
    
    // SignUp Netowking method. Will POST email and password to sign up.
    func signUp(_ email: String, _ password: String) {
        networkManager.signUpPost(email, password) { result in
            switch result {
            case let .success(result):
                // TODO: Do something with result (which is probably going to be the response)
                print(result)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // Login Networking Method. Will POST email and password to Login.
    func logIn(_ email: String, _ password: String) {
        networkManager.logInPost(email, password) { result in
            switch result {
            case let .success(result):
                // TODO: Do something with result (which is probably going to be the response)
                print(result)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // Action when begins to edit any textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Began Editing")
    }
    
    // Hide keyboard when return is pressed on any keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do
        return false
    }
}

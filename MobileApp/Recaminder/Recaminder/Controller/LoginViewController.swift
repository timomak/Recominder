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
        textField.keyboardType = UIKeyboardType.emailAddress
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
        textField.isSecureTextEntry = true
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
        textField.isSecureTextEntry = true
        textField.returnKeyType = UIReturnKeyType.done
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
    
    // Error label
    let errorLabel: UITextView = {
        var title = UITextView()
        title.text = "Error"
        title.font = UIFont(name: "AvenirNext-Bold", size: 15)
        title.textColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        title.isHidden = true
        return title
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
        passwordViewContainer.anchor(top: emailViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 50))
        
        passwordViewContainer.centerHorizontalOfView(to: emailViewContainer)
        passwordTextField.anchor(top: passwordViewContainer.topAnchor, leading: passwordViewContainer.leadingAnchor, bottom: passwordViewContainer.bottomAnchor, trailing: passwordViewContainer.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        // Register constraints
        logInOrSignUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        // Continue constrains
        continueButton.anchor(top: emailViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 200, left: 50, bottom: 0, right: 50))
        
        
        // Error message label
        view.addSubview(errorLabel)
        errorLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: emailViewContainer.topAnchor, trailing: view.trailingAnchor)
    }
    
    // Changing between Sign in and Log in
    @objc func registerButtonPressed() {
        if isLoggingIn == true {
            logInOrSignUpButton.setTitle("Login?", for: .normal)
            isLoggingIn = false
            
            // Adding password confirmation for signup
            view.addSubview(confirmPasswordViewContainer)
            view.addSubview(confirmPasswordTextField)
            confirmPasswordTextField.delegate = self
            
            // Password confirmation constrains
            confirmPasswordViewContainer.anchor(top: emailViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 110, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 50))
            
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
    
    private func incorrectPassword(_ withEmail: Bool = false) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordViewContainer.center.x - 10, y: passwordViewContainer.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: passwordViewContainer.center.x + 10, y: passwordViewContainer.center.y))
        
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.duration = 0.07
        animation2.repeatCount = 4
        animation2.autoreverses = true
        animation2.fromValue = NSValue(cgPoint: CGPoint(x: confirmPasswordViewContainer.center.x - 10, y: confirmPasswordViewContainer.center.y))
        animation2.toValue = NSValue(cgPoint: CGPoint(x: confirmPasswordViewContainer.center.x + 10, y: confirmPasswordViewContainer.center.y))

        
        confirmPasswordTextField.textColor = #colorLiteral(red: 0.9599618316, green: 0.275388211, blue: 0.4092237353, alpha: 1)
        confirmPasswordViewContainer.layer.add(animation2, forKey: "position")
        
        passwordTextField.textColor = #colorLiteral(red: 0.9599618316, green: 0.275388211, blue: 0.4092237353, alpha: 1)
        passwordViewContainer.layer.add(animation, forKey: "position")
        
        if withEmail == true {
            let animation3 = CABasicAnimation(keyPath: "position")
            animation3.duration = 0.07
            animation3.repeatCount = 4
            animation3.autoreverses = true
            animation3.fromValue = NSValue(cgPoint: CGPoint(x: emailViewContainer.center.x - 10, y: emailViewContainer.center.y))
            animation3.toValue = NSValue(cgPoint: CGPoint(x: emailViewContainer.center.x + 10, y: emailViewContainer.center.y))
            
            emailViewContainer.layer.add(animation3, forKey: "position")
        }
    }
    
    @objc func continueButtonPressed() {
        print("Continue pressed")
        // Check if fields are not empty
        if passwordTextField.text != "" || emailTextField.text != "" {
            if isLoggingIn == false {
                // Check if password is correct
                if passwordTextField.text != confirmPasswordTextField.text {
                    incorrectPassword()
                    displayError("Passwords don't match")
                }
                else {
                    // TODO: Handle Signup
                     signUp(emailTextField.text!, passwordTextField.text!)
                }
            }
            else {
                // TODO: Handle Log in
                 logIn(emailTextField.text!, passwordTextField.text!)
            }
        }
        else {
            // Animation for empty fields
            incorrectPassword(true)
            displayError("Input fields empty")
        }
    }
    
    let networkManager = NetworkManager()
    
    // SignUp Netowking method. Will POST email and password to sign up.
    func signUp(_ email: String, _ password: String) {
        print("signing up")
        networkManager.signUpPost(email, password) { result in
            switch result {
            case let .success(result):
                // TODO: Do something with result (which is probably going to be the response)
                print("sign up: ",result)
            case let .failedSigning(result):
                print("Failed Sign up: ", result)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // Login Networking Method. Will POST email and password to Login.
    func logIn(_ email: String, _ password: String) {
        print("logging in")
        networkManager.logInPost(email, password) { result in
            switch result {
            case let .success(result):
                // TODO: Do something with result (which is probably going to be the response)
                print("log in result: ",result)
            case let .failedSigning(result):
                print("Failed Log in: ", result)
                self.displayError("\(result)")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // Add error label with string for the error
    func displayError(_ text: String) {
        errorLabel.isHidden = false
        errorLabel.text = text
    }
    
    // Action when begins to edit any textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0.9328219295, green: 0.6075096726, blue: 0.6003844142, alpha: 1)
        errorLabel.isHidden = true
    }
    
    // Hide keyboard when return is pressed on any keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, sign in or log in
//            textField.resignFirstResponder()
            continueButtonPressed()
        }
        // Do
        return false
    }
}

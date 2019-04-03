//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/25/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setting the fields to empty text so that when user clicks on logout and comes back the entered text is still present.
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func validateLogin(_ sender: Any) {
        loginActivityIndicator.startAnimating()
        configureUIDuringLogin(isEnabled: false)
        UdacityClient.createSessionId(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleSessionResponse(success:error:))
    }
    
    @IBAction func signUp(_ sender: Any) {
        let signUpURL = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")
        if let signUpURL = signUpURL {
            UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
        }
    }
    
    private func handleSessionResponse(success: Bool, error: Error?) {
        self.loginActivityIndicator.stopAnimating()
        configureUIDuringLogin(isEnabled: true)
        if success {
            self.performSegue(withIdentifier: "NavController", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    private func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        show(alertVC, sender: nil)
    }
    
    private func configureUIDuringLogin(isEnabled: Bool) {
        emailTextField.isEnabled = isEnabled
        passwordTextField.isEnabled = isEnabled
        loginButton.isEnabled = isEnabled
    }
    
}


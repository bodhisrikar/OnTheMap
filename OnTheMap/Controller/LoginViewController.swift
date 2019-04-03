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

    @IBAction func validateLogin(_ sender: Any) {
        loginActivityIndicator.startAnimating()
        UdacityClient.createSessionId(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleSessionResponse(success:error:))
    }
    
    private func handleSessionResponse(success: Bool, error: Error?) {
        self.loginActivityIndicator.stopAnimating()
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
    
}


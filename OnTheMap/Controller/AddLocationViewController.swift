//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/27/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var findLocationActivityIndicator: UIActivityIndicatorView!
    
    let customTextFieldDelegate = CustomTextFieldDelegate()
    var placeMark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = customTextFieldDelegate
        linkTextField.delegate = customTextFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        if linkTextField.text?.isEmpty ?? false {
            handleEmptyLink(errorMessage: "The link cannot be empty. Please provide a valid URL")
            return
        }
        
        if locationTextField.text?.isEmpty ?? false {
            handleEmptyLink(errorMessage: "The location cannot be empty. Please provide a valid location")
            return
        }
        
        findLocationActivityIndicator.startAnimating()
        configureUI(isEnabled: false)
        let validateGeocode = CLGeocoder()
        validateGeocode.geocodeAddressString(locationTextField.text!, completionHandler: handleGeocodeResponse(placeMark:error:))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let placeMark = placeMark {
            let submitLocationVC = segue.destination as! SubmitLocationController
            submitLocationVC.placeMark = placeMark
            submitLocationVC.placeURL = linkTextField.text ?? "www.google.com"
        }
    }
    
    private func handleEmptyLink(errorMessage: String) {
        let emptyLinkAlertVC = UIAlertController(title: "Submit Failed", message: errorMessage, preferredStyle: .alert)
        emptyLinkAlertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(emptyLinkAlertVC, animated: true, completion: nil)
    }
    
    private func handleGeocodeResponse(placeMark: [CLPlacemark]?, error: Error?) {
        findLocationActivityIndicator.stopAnimating()
        configureUI(isEnabled: true)
        if let placeMark = placeMark {
            self.placeMark = placeMark[0]
            performSegue(withIdentifier: "SubmitLocationController", sender: nil)
        } else {
            showFindLocationFailure(message: error?.localizedDescription ?? "Enter a valid location")
        }
    }
    
    private func configureUI(isEnabled: Bool) {
        locationTextField.isEnabled = isEnabled
        linkTextField.isEnabled = isEnabled
        findLocationButton.isEnabled = isEnabled
    }
    
    private func showFindLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        show(alertVC, sender: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if linkTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height / 2
    }

}

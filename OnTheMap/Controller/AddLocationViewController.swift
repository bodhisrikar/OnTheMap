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
    
    var placeMark: CLPlacemark!
    
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

}

//
//  CustomTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 4/3/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit

class CustomTextFieldDelegate: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}

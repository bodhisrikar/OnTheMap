//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/27/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UdacityClient.getAllStudentsLocations(completionHandler: handleLocationResponse(response:error:))
    }

    @IBAction func logout(_ sender: Any) {
        UdacityClient.deleteSessionId(completionHandler: handleDeleteSessionResponse(success:error:))
    }
    
    @IBAction func refreshStudentLocations(_ sender: Any) {
        appDelegate.allStudentsLocations = [AllStudentsLocationDetailsResponse]() // entire dataset should be refreshed. Intializing it back to an empty array.
        UdacityClient.getAllStudentsLocations(completionHandler: handleLocationResponse(response:error:))
    }
    
    @IBAction func addStudentLocation(_ sender: Any) {
        let locationVC = storyboard?.instantiateViewController(withIdentifier: "LocationNavController") as! UINavigationController
        present(locationVC, animated: true, completion: nil)
    }
    
    private func handleDeleteSessionResponse(success: Bool, error: Error?) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(loginVC, animated: true, completion: nil)
    }
    
    private func handleLocationResponse(response: AllStudentsLocationResponse?, error: Error?) {
        if let response = response {
            appDelegate.allStudentsLocations = response.results
        }
    }
}

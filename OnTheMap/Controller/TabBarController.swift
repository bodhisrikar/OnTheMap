//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/27/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    @IBAction func logout(_ sender: Any) {
        UdacityClient.deleteSessionId(completionHandler: handleDeleteSessionResponse(success:error:))
    }
    
    @IBAction func refreshStudentLocations(_ sender: Any) {
        let customRefreshNotification = NotificationCenter.default
        customRefreshNotification.post(name: Notification.Name("RefreshStudentLocations"), object: nil)
    }
    
    @IBAction func addStudentLocation(_ sender: Any) {
        let locationVC = storyboard?.instantiateViewController(withIdentifier: "LocationNavController") as! UINavigationController
        present(locationVC, animated: true, completion: nil)
    }
    
    private func handleDeleteSessionResponse(success: Bool, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

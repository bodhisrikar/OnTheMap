//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/31/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UIViewController {
    
    @IBOutlet weak var studentLocationTableView: UITableView!
    let locationNofication = NotificationCenter.default
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStudentLocations()
        locationNofication.addObserver(self, selector: #selector(updateStudentLocations), name: Notification.Name("RefreshStudentsLocations"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationNofication.removeObserver(self)
    }
}

extension StudentLocationTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.allStudentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableIdentifier = "StudentLocationCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as! UITableViewCell
        let location = StudentLocations.allStudentsLocations[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = location.firstName
        cell.detailTextLabel?.text = location.lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: StudentLocations.allStudentsLocations[indexPath.row].mediaURL)
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func updateStudentLocations() {
        UdacityClient.getAllStudentsLocations(completionHandler: handleLocationResponse(response:error:))
    }
    
    private func handleLocationResponse(response: AllStudentsLocationResponse?, error: Error?) {
        if let response = response {
            StudentLocations.allStudentsLocations = response.results
            self.studentLocationTableView.reloadData()
        }
    }
    
}

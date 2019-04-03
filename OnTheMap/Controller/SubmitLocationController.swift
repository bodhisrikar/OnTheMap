//
//  SubmitLocationController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/28/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SubmitLocationController: UIViewController {
    var placeMark: CLPlacemark!
    var placeURL: String!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        navigationController?.navigationItem.title = "Submit Location"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let placeMark = placeMark {
            let resultLatitude = CLLocationDegrees(placeMark.location?.coordinate.latitude ?? 0.0)
            let resultLongitude = CLLocationDegrees(placeMark.location?.coordinate.longitude ?? 0.0)
            let resultCoordinate = CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = resultCoordinate
            let locality = placeMark.locality
            let administrativeArea = placeMark.administrativeArea
            let country = placeMark.country
            annotation.title = "\(locality!), \(administrativeArea!), \(country!)"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func postStudentLocation(_ sender: Any) {
        UdacityClient.postStudentLocation(firstName: "first", lastName: "last", mapString: "\(placeMark.locality!), \(placeMark.administrativeArea!)", mediaURL: placeURL, latitude: placeMark.location?.coordinate.latitude ?? 0.0, longitude: placeMark.location?.coordinate.longitude ?? 0.0, completionHandler: handlePostStudentLocationResponse(response:error:))
    }
    
    private func handlePostStudentLocationResponse(response: PostStudentLocationResponse?, error: Error?) {
        guard let response = response else {
            showSubmitFailure(message: error?.localizedDescription ?? "Please try again")
            return
        }
        
        StudentLocations.allStudentsLocations.append(AllStudentsLocationDetailsResponse(createdAt: response.createdAt, firstName: "first", lastName: "last", latitude: placeMark.location?.coordinate.latitude ?? 0.0, longitude: placeMark.location?.coordinate.longitude ?? 0.0, mapString: "\(placeMark.locality!), \(placeMark.administrativeArea!)", mediaURL: placeURL, objectId: response.objectId, uniqueKey: UdacityClient.Auth.accountKey, updatedAt: "\(Calendar.current.component(.hour, from: Date()))"))
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    private func showSubmitFailure(message: String) {
        let alertVC = UIAlertController(title: "Submit Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        show(alertVC, sender: nil)
    }
}

extension SubmitLocationController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinReuseIdentifier = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinReuseIdentifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinReuseIdentifier)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle {
                let openURL = URL(string: open!)
                UIApplication.shared.open(openURL!, options: [:], completionHandler: nil)
            }
        }
    }
}

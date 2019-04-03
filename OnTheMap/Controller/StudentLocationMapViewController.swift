//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/26/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationNofication = NotificationCenter.default
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = false
        updateStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.addAnnotations(annotations)
        
        locationNofication.addObserver(self, selector: #selector(updateStudentLocations), name: Notification.Name("RefreshStudentsLocations"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationNofication.removeObserver(self)
    }
    
}

extension StudentLocationMapViewController: MKMapViewDelegate {
    
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
    
    @objc func updateStudentLocations() {
        UdacityClient.getAllStudentsLocations(completionHandler: handleLocationResponse(response:error:))
    }
    
    private func handleLocationResponse(response: AllStudentsLocationResponse?, error: Error?) {
        if let response = response {
            StudentLocations.allStudentsLocations = response.results
            let locationResults = StudentLocations.allStudentsLocations
            
            for location in locationResults {
                let resultLatitude = CLLocationDegrees(location.latitude)
                let resultLongitude = CLLocationDegrees(location.longitude)
                let resultCoordinate = CLLocationCoordinate2D(latitude: resultLatitude, longitude: resultLongitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = resultCoordinate
                annotation.title = "\(location.firstName) \(location.lastName)"
                annotation.subtitle = location.mediaURL
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        }
    }
}

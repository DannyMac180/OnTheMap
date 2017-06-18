//
//  MapKitViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/9/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    var annotations = [MKPointAnnotation]()
    var parseClient = ParseClient.sharedInstance()
    var udacityClient = UdacityClient.sharedInstance()
    var studentModel = StudentModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        mapView.delegate = self
        var studentLocations = StudentModel.sharedInstance.studentsArray
        
        for student in studentLocations {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = student.firstName
            let lastName = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        parseClient.getMutlipleStudentLocations() { (studentLocations, error) in
            DispatchQueue.main.async {
                if let studentLocations = studentLocations {
                    for student in studentLocations {
                        self.studentModel.studentsArray.append(student)
                    }
                } else {
                    self.alertWithError(error: "The download failed.")
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        udacityClient.logoutWithUdacity() { (id, expiration, error) in
            if let expiration = expiration {
                print("success")
            } else {
                print(error)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func alertWithError(error: String) {
        let alertView = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}

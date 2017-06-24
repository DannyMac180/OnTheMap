//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 6/7/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    
    var mapString = String()
    var mediaURL = String()
    var placemark: CLPlacemark? = nil
    
    var currentUser = StudentModel.sharedInstance.currentUser
    var parseClient = ParseClient.sharedInstance()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
    }

    @IBAction func finish(_ sender: Any) {
        parseClient.postStudentLocation(uniqueKey: (currentUser?.accountKey)!, firstName: (currentUser?.firstName)!, lastName: (currentUser?.lastName)!, mapString: self.mapString, mediaUrl: self.mediaURL, latitude: (placemark?.location?.coordinate.latitude)!, longitude: (placemark?.location?.coordinate.longitude)!) { (createdAt, objectId, error) in
            
            DispatchQueue.main.async {
            if let createdAt = createdAt {
                print("success")
            } else {
                self.alertWithError(error: "Unsuccessful in creating location.")
            }
        }
    }
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func alertWithError(error: String) {
        let alertView = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}

//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 6/7/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import MapKit

class CofirmLocationViewController: UIViewController {
    
    var mapString: String = ""
    var mediaURL: String = ""
    var placemark: CLPlacemark? = nil
    var studentModel = StudentModel.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        print("Test")
    }

    @IBAction func finish(_ sender: Any) {
    
    }
    
}

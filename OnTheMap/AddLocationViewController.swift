//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/11/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterWebsiteTextField: UITextField!
    
    var placemark: CLPlacemark? = nil
    var mapString: String = ""
    var mediaURL: String = ""
    
    @IBAction func findLocation(_ sender: Any) {
        
        if (enterLocationTextField.text?.isEmpty)! {
            showAlert(message: "Please enter a location.")
            return
        }
        
        if (enterWebsiteTextField.text?.isEmpty)! {
            showAlert(message: "Please enter a valid website.")
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(enterLocationTextField.text!) { (placemarkArr, error) in
            
            if let _ = error {
                self.showAlert(message: "Could not gecode the given location.")
            } else if (placemarkArr?.isEmpty)! {
                self.showAlert(message: "Location not found.")
            } else {
                self.placemark = placemarkArr?.first
                self.mediaURL = self.enterWebsiteTextField.text!
                self.mapString = self.enterWebsiteTextField.text!
                
                func prepare(for segue: UIStoryboardSegue, sender: AnyObject) {
                    if segue.identifier == "findLocationSegue" {
                        let destination = segue.destination as! CofirmLocationViewController
                        destination.placemark = self.placemark
                        destination.mediaURL = self.mediaURL
                        destination.mapString = self.mapString
                    }
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(message: String, completionClosure: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: completionClosure))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

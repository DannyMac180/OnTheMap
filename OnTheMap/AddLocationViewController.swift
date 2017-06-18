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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var placemark: CLPlacemark? = nil
    var mediaURL = String()
    var mapString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        enterLocationTextField.delegate = self
        enterWebsiteTextField.delegate = self
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
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
                self.activityIndicator.isHidden = true
            } else if (placemarkArr?.isEmpty)! {
                self.showAlert(message: "Location not found.")
                self.activityIndicator.isHidden = true
            } else {
                self.placemark = placemarkArr?.first
                self.mediaURL = self.enterWebsiteTextField.text!
                self.mapString = self.enterLocationTextField.text!
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                self.performSegue(withIdentifier: "FindLocationSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindLocationSegue" {
            let destination = segue.destination as! ConfirmLocationViewController
            destination.placemark = placemark
            destination.mediaURL = mediaURL
            destination.mapString = mapString
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

extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

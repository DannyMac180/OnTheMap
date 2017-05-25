//
//  ViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseClient.sharedInstance().postStudentLocation(uniqueKey: "1234", firstName: "John", lastName: "Doe", mapString: "Anytown, USA", mediaUrl: "google.com", latitude: 0.00, longitude: 0.00) { (success, error) in
            if let success = success {
                print(success)
            } else {
                print(error)
            }
        }
    }
}

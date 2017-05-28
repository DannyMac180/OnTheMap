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
        
        UdacityClient.sharedInstance().logoutWithUdacity() { (id, expiration, error) in
            
            if let id = id {
                print(id)
            } else {
                print(error)
            }
        }
    }
}

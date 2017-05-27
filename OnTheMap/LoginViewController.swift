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
        
        ParseClient.sharedInstance().updateStudentLocation(objectId: "UnXoAD3Mgv", uniqueKey: "1111", firstName: "Wilt", lastName: "Chamberlain", mapString: "Los Angeles, CA", mediaUrl: "lalakers.com", latitude: 0.00, longitude: 0.00) { (updatedAt, error) in
         
            if let updatedAt = updatedAt {
                print(updatedAt)
            } else {
                print(error)
            }
        }
    }
}

//
//  ViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum UIElementState { case Initialize, Normal, Login }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let udacityClient = UdacityClient.sharedInstance()
    let studentModel = StudentModel.sharedInstance()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(.Initialize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews(.Normal)
        
        emailTextField.delegate = self
        passwordTextfield.delegate = self
    }
    
    func setupViews(_ state: UIElementState) {
        switch state {
            
        case .Initialize:
            loginButton.layer.cornerRadius = 4.0
            passwordTextfield.isSecureTextEntry = true
            errorLabel.text = ""
            
        case .Normal:
            UIApplication.shared.endIgnoringInteractionEvents()
            setEnabled(enabled: true)
            emailTextField.text = ""
            passwordTextfield.text = ""
            activityIndicator.stopAnimating()
            stackView.alpha = 1.0
            
        case .Login:
            setEnabled(enabled: false)
            activityIndicator.startAnimating()
            stackView.alpha = 0.5
            errorLabel.text = ""
        }
    }
    
    private func setEnabled(enabled: Bool){
        activityIndicator.isHidden = enabled
        loginButton.isEnabled = enabled
        emailTextField.isEnabled = enabled
        passwordTextfield.isEnabled = enabled
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

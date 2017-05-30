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
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let udacityClient = UdacityClient.sharedInstance()
    var studentModel = StudentModel.sharedInstance()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(.Initialize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews(.Normal)
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty {
            throwError()
        } else {
            
            setupViews(.Login)
            
            udacityClient.authenticateUdacitySession(username: emailTextfield.text!, password: passwordTextfield.text!) { (key, error) in
                
                DispatchQueue.main.async {
                    if let key = key {
                        self.udacityClient.getStudentData(accountKey: key) { (student, error) in
                            DispatchQueue.main.async {
                                if let student = student {
                                    self.studentModel.currentUser = student
                                    self.performSegue(withIdentifier: Constants.Identifiers.loginSegue, sender: self)
                                } else {
                                    self.alertWithError(error: error as! String)
                                }
                            }
                        }
                    } else {
                        self.alertWithError(error: error as! String)
                    }
                }
            }
        }
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
            emailTextfield.text = ""
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
        emailTextfield.isEnabled = enabled
        passwordTextfield.isEnabled = enabled
    }
    
    private func throwError() {
        if emailTextfield.text!.isEmpty {
            animateOnError(textField: emailTextfield)
            errorLabel.text = "Username is empty"
        } else {
            animateOnError(textField: passwordTextfield)
            errorLabel.text = "Password is empty"
        }
    }
    
    private func animateOnError(textField: UITextField) {
        
        UIView.animate(withDuration: 1.0){
            let animate = CABasicAnimation.init(keyPath: "shake")
            animate.duration = 0.1
            animate.repeatCount = 2
            animate.autoreverses = true
            animate.fromValue = NSValue(cgPoint: CGPoint(x: self.stackView.center.x - 5, y: self.stackView.center.y))
            animate.toValue = NSValue(cgPoint: CGPoint(x: self.stackView.center.x + 5, y: self.stackView.center.y))
            self.stackView.layer.add(animate, forKey: "shake")
        }
    }
    
    func alertWithError(error: String) {
        setupViews(.Normal)
        let alertView = UIAlertController(title: "LoginAlertTitle", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

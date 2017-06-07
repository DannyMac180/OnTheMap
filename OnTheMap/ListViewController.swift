//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/11/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var studentModel = StudentModel.sharedInstance
    var parseClient = ParseClient.sharedInstance()
    
    override func viewDidLoad() {
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let rect = self.navigationBar.frame
        let y = rect.size.height + rect.origin.y
        self.tableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentModel.studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        let student = self.studentModel.studentsArray[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mediaUrl = self.studentModel.studentsArray[indexPath.row].mediaURL
        
        if let studentMediaURL = URL(string: mediaUrl), UIApplication.shared.canOpenURL(studentMediaURL) {
            UIApplication.shared.open(studentMediaURL)
        } else {
            alertWithError(error: "Unable to open webpage.")
        }
    }
    
    func alertWithError(error: String) {
        let alertView = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true){
            self.view.alpha = 1.0
        }
    }

    @IBAction func refresh(_ sender: Any) {
        self.tableView.reloadData()
    }

    
    @IBAction func logout(_ sender: Any) {
    
    }
}

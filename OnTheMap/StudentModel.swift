//
//  DataSource.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/28/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class StudentModel: NSObject {
    
    var studentsArray = [StudentLocation]()
    var currentUser: StudentInfo?
    
    static let sharedInstance = StudentModel()
    
    class func sharedStudentModel() -> StudentModel  {
        return sharedInstance
    }
   
}

//
//  DataSource.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/28/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

struct StudentModel {
    
    var studentsArray: [StudentInfo] = []
    var currentUser: StudentInfo? = nil
    
    static func sharedInstance() -> StudentModel {
        struct Singleton {
            static var sharedInstance = StudentModel()
        }
        return Singleton.sharedInstance
    }
}

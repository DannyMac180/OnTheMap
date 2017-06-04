//
//  Student.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/27/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

struct StudentInfo {
    
    var accountKey: String
    var firstName: String
    var lastName: String
    var mediaURL: String
    
    init(accountKey: String, firstName: String, lastName: String, mediaURL: String) {
        self.accountKey = accountKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
    }
}

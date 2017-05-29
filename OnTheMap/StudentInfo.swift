//
//  Student.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/27/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

struct StudentInfo {
    
    let accountKey: String
    let firstName: String
    let lastName: String
    var mediaURL: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(accountKey: String, firstName: String, lastName: String, mediaURL: String) {
        self.accountKey = accountKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
    }
}

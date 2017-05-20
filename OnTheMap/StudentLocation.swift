//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/17/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    // MARK: Properties
    var objectId: String
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    // MARK: Initializers
    
    init(dictionary: [String: AnyObject]) {
        objectId = dictionary[Constants.Parse.JSONResponseKeys.objectId] as? String ?? ""
        uniqueKey = dictionary[Constants.Parse.JSONResponseKeys.uniqueKey] as? String ?? ""
        firstName = dictionary[Constants.Parse.JSONResponseKeys.firstName] as? String ?? ""
        lastName = dictionary[Constants.Parse.JSONResponseKeys.lastName] as? String ?? ""
        mapString = dictionary[Constants.Parse.JSONResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[Constants.Parse.JSONResponseKeys.mediaURL] as? String ?? ""
        latitude = dictionary[Constants.Parse.JSONResponseKeys.latitude] as? Double ?? 0.0
        longitude = dictionary[Constants.Parse.JSONResponseKeys.longitude] as? Double ?? 0.0
    }
    
    static func studentLocationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
    
}

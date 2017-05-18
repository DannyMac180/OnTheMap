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
        objectId = dictionary[Constants.Parse.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[Constants.Parse.JSONResponseKeys.UniqueKey] as? String ?? ""
        firstName = dictionary[Constants.Parse.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[Constants.Parse.JSONResponseKeys.LastName] as! String
        mapString = dictionary[Constants.Parse.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[Constants.Parse.JSONResponseKeys.MediaURL] as! String
        latitude = dictionary[Constants.Parse.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[Constants.Parse.JSONResponseKeys.Longitude] as! Double
    }
    
    static func studentLocationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
    
}

//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/15/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session = URLSession.shared
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func taskForUdacityRequest()
    
}

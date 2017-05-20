//
//  Constants.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/15/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

struct Constants {
    
    struct Udacity {
        static let baseUrl = "https://www.udacity.com/"
    }
    
    struct Parse {
        
        struct APIComponents {
            static let scheme = "https"
            static let host = "parse.udacity.com"
            static let path = "/parse/classes"
        }
        
        struct Methods {
            static let studentLocation = "/StudentLocation"
        }
        
        struct HeaderKeys {
            static let apiKey = "X-Parse-REST-API-Key"
            static let appId =  "X-Parse-Application-Id"
            static let accept = "Accept"
            static let content_type = "Content-Type"
        }
        
        struct HeaderValues {
            static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let appId =  "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let application_json = "application/json"

        }
        
        struct ParameterKeys {
            static let limit = "limit"
            static let order = "order"
            static let Where = "where"
            static let uniqueKey = "uniqueKey"
        }
        
        struct ParamterValues {
            static let hundred = 100
        }
        
        struct JSONResponseKeys {
            static let results = "results"
            static let objectId = "objectId"
            static let uniqueKey = "uniqueKey"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let mapString = "mapString"
            static let mediaURL = "mediaURL"
            static let latitude = "latitude"
            static let longitude = "longitude"
        }
        
        struct HTTPMethods {
            static let get = "GET"
            static let post = "POST"
            static let put = "PUT"
        }
    }
}

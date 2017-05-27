//
//  Constants.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/15/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

struct Constants {
        
        struct UdacityAPIComponents {
            static let scheme = "https"
            static let host =   "www.udacity.com"
            static let path =   "/api/session"
        }
        
        struct ParseAPIComponents {
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
            static let udacity = "udacity"
            static let username = "username"
            static let password = "password"
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
            static let createdAt = "createdAt"
            static let updatedAt = "updatedAt"
            static let account = "account"
            static let session = "session"
            static let registered = "registered"
            static let key = "key"
            static let id = "id"
            static let expiration = "expiration"
        }
        
        struct StudentLocKeys {
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

//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/20/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session = URLSession.shared
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    func taskForParseRequest(requestType: String, optionalParameters: [String: AnyObject], pathExtension: String?, addContentType: Bool, httpBody: String?, completionHandlerForParseRequest: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(optionalParameters, method: Constants.Methods.studentLocation, withPathExtension: pathExtension))
        request.httpMethod = requestType
        request.addValue(Constants.HeaderValues.appId, forHTTPHeaderField: Constants.HeaderKeys.appId)
        request.addValue(Constants.HeaderValues.apiKey, forHTTPHeaderField: Constants.HeaderKeys.apiKey)
        
        if let httpBody = httpBody {
            request.httpBody = httpBody.data(using: String.Encoding.utf8)
        }
        
        if addContentType {
            request.addValue(Constants.HeaderValues.application_json, forHTTPHeaderField: Constants.HeaderKeys.content_type)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParseRequest(nil, NSError(domain: "taskForParseRequest", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParseRequest)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    func getMutlipleStudentLocations(_ completionHandlerForMultipleStudentLocations: @escaping (_ studentLocations: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        let parameters = [Constants.ParameterKeys.limit: Constants.ParamterValues.hundred, Constants.ParameterKeys.order: Constants.ParamterValues.updatedAt] as [String : Any]
        
        let _ = taskForParseRequest(requestType: Constants.HTTPMethods.get, optionalParameters: parameters as [String : AnyObject], pathExtension: nil, addContentType: false, httpBody: nil)  { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForMultipleStudentLocations(nil, error)
                return
            }
            
            if let results = result?[Constants.JSONResponseKeys.results] as? [[String: AnyObject]] {
                
                let studentLocations = StudentLocation.studentLocationsFromResults(results)
                completionHandlerForMultipleStudentLocations(studentLocations, nil)
            } else {
                completionHandlerForMultipleStudentLocations(nil, NSError(domain: "getMultipleStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMultipleStudentLocations"]))
            }
        }
    }
    
    func getSingleStudentLocation(uniqueKey: String, completionHandlerForSingleStudentLocation: @escaping (_ studentLocation: StudentLocation?, _ error: NSError?) -> Void) {
        
        let parameters = ["\(Constants.ParameterKeys.Where)": "{\"\(Constants.ParameterKeys.uniqueKey)\":\"" + "\(uniqueKey)" + "\"}"]
        
        let _ = taskForParseRequest(requestType: Constants.HTTPMethods.get, optionalParameters: parameters as [String: AnyObject], pathExtension: nil, addContentType: false, httpBody: nil) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForSingleStudentLocation(nil, error)
                return
            }
            
            if let results = result?[Constants.JSONResponseKeys.results] as? [[String: AnyObject]] {
                
                if results.count == 1 {
                    let studentLocation = StudentLocation.studentLocationsFromResults(results)
                    completionHandlerForSingleStudentLocation(studentLocation[0], nil)
                } else if results.count > 1 {
                    print("There is more than one user with this 'Unique Key'")
                } else {
                    completionHandlerForSingleStudentLocation(nil, NSError(domain: "getSingleStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSingleStudentLocation"]))
                }
            }
        }
    }
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPostStudentLocation: @escaping ( _ createdAt: String?, _ objectId: String?, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let httpBody = "{\"\(Constants.StudentLocKeys.uniqueKey)\": \"\(uniqueKey)\", \"\(Constants.StudentLocKeys.firstName)\": \"\(firstName)\", \"\(Constants.StudentLocKeys.lastName)\": \"\(lastName)\",\"\(Constants.StudentLocKeys.mapString)\": \"\(mapString)\", \"\(Constants.StudentLocKeys.mediaURL)\": \"\(mediaUrl)\",\"\(Constants.StudentLocKeys.latitude)\": \(latitude), \"\(Constants.StudentLocKeys.longitude)\": \(longitude)}"
        
        let _ = taskForParseRequest(requestType: Constants.HTTPMethods.post, optionalParameters: parameters, pathExtension: nil, addContentType: true, httpBody: httpBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForPostStudentLocation(nil, nil, error)
                return
            }
            
            if let createdAt = result?[Constants.JSONResponseKeys.createdAt], let objectId = result?[Constants.JSONResponseKeys.objectId] {
                completionHandlerForPostStudentLocation(createdAt as! String?, objectId as! String?, nil)
            } else {
                completionHandlerForPostStudentLocation(nil, nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
            }
        }
    }
    
    func updateStudentLocation(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForUpdateStudentLocation: @escaping ( _ updatedAt: String?, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let httpBody = "{\"\(Constants.StudentLocKeys.uniqueKey)\": \"\(uniqueKey)\", \"\(Constants.StudentLocKeys.firstName)\": \"\(firstName)\", \"\(Constants.StudentLocKeys.lastName)\": \"\(lastName)\",\"\(Constants.StudentLocKeys.mapString)\": \"\(mapString)\", \"\(Constants.StudentLocKeys.mediaURL)\": \"\(mediaUrl)\",\"\(Constants.StudentLocKeys.latitude)\": \(latitude), \"\(Constants.StudentLocKeys.longitude)\": \(longitude)}"
        
        let pathExtension = "/\(objectId)"
        
        let _ = taskForParseRequest(requestType: Constants.HTTPMethods.put, optionalParameters: parameters, pathExtension: pathExtension, addContentType: true, httpBody: httpBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForUpdateStudentLocation(nil, error)
                return
            }
            
            if let updatedAt = result?[Constants.JSONResponseKeys.updatedAt] {
                completionHandlerForUpdateStudentLocation(updatedAt as! String?, nil)
            } else {
                completionHandlerForUpdateStudentLocation(nil, NSError(domain: "updateStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateStudentLocation"]))
            }
            
        }
    }
    
    private func parseURLFromParameters(_ parameters: [String:AnyObject], method: String? = nil, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ParseAPIComponents.scheme
        components.host = Constants.ParseAPIComponents.host
        components.path = Constants.ParseAPIComponents.path + (method ?? "") + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}

//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Daniel McAteer on 5/20/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

class ParseClient {
    
    var session = URLSession.shared
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    func taskForParseRequest(requestType: String, optionalParameters: [String: AnyObject], completionHandlerForParseRequest: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(optionalParameters, withPathExtension: Constants.Parse.Methods.studentLocation))
        request.httpMethod = requestType
        request.addValue(Constants.Parse.HeaderValues.appId, forHTTPHeaderField: Constants.Parse.HeaderKeys.appId)
        request.addValue(Constants.Parse.HeaderValues.apiKey, forHTTPHeaderField: Constants.Parse.HeaderKeys.apiKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParseRequest(nil, NSError(domain: "taskForParseRequest", code: 1, userInfo: userInfo))
                print(request)
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
        
        let parameters = [Constants.Parse.ParameterKeys.limit: Constants.Parse.ParamterValues.hundred]
        
        let _ = taskForParseRequest(requestType: Constants.Parse.HTTPMethods.get, optionalParameters: parameters as [String : AnyObject])  { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForMultipleStudentLocations(nil, error)
                return
            }
            
            if let results = result?[Constants.Parse.JSONResponseKeys.results] as? [[String: AnyObject]] {
                
                let studentLocations = StudentLocation.studentLocationsFromResults(results)
                completionHandlerForMultipleStudentLocations(studentLocations, nil)
            } else {
                completionHandlerForMultipleStudentLocations(nil, NSError(domain: "getMultipleStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMultipleStudentLocations"]))
            }
        }
    }
    
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.APIComponents.scheme
        components.host = Constants.Parse.APIComponents.host
        components.path = Constants.Parse.APIComponents.path + (withPathExtension ?? "")
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

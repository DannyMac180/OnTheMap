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
    
    func authenticateUdacitySession(username: String, password: String, completionHandlerForUdacityAuthentication: @escaping ( _ key: String?, _ id: String?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(withMethod: Constants.Methods.session, withPathExtension: nil))
        request.httpMethod = Constants.HTTPMethods.post
        request.addValue(Constants.HeaderValues.application_json, forHTTPHeaderField: Constants.HeaderKeys.accept)
        request.addValue(Constants.HeaderValues.application_json, forHTTPHeaderField: Constants.HeaderKeys.content_type)
        request.httpBody = "{\"\(Constants.ParameterKeys.udacity)\": {\"\(Constants.ParameterKeys.username)\": \"\(username)\", \"\(Constants.ParameterKeys.password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print(request)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForUdacityAuthentication(nil, nil, NSError(domain: "authenticateUdacitySession", code: 1, userInfo: userInfo))
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
            
            let range = Range(5..<data.count)
            
            let newData = data.subdata(in: range)
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                sendError("JSONSerialization did not work.")
            }
            
            if let account = parsedResult?[Constants.JSONResponseKeys.account] as? [String: AnyObject], let session = parsedResult?[Constants.JSONResponseKeys.session] as? [String: AnyObject] {
                if let key = account[Constants.JSONResponseKeys.key] as? String,  let id = session[Constants.JSONResponseKeys.id] as? String {
                    completionHandlerForUdacityAuthentication(key, id, nil)
                }
            } else {
                completionHandlerForUdacityAuthentication(nil, nil, error as? NSError)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func logoutWithUdacity(completionHandlerForLogoutWithUdacity: @escaping (_ id: String?, _ expiration: String?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(withMethod: Constants.Methods.session, withPathExtension: nil))
        request.httpMethod = Constants.HTTPMethods.delete
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Constants.Cookies.xsrfToken {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.HeaderKeys.xsrfToken)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print(request)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogoutWithUdacity(nil, nil, NSError(domain: "logOutWithUdacity", code: 1, userInfo: userInfo))
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
            
            let range = Range(5..<data.count)
            
            let newData = data.subdata(in: range)
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                sendError("JSONSerialization failed.")
            }
            
            if let session = parsedResult?[Constants.JSONResponseKeys.session] as? [String: AnyObject] {
                if let id = session[Constants.JSONResponseKeys.id] as? String, let expiration = session[Constants.JSONResponseKeys.expiration]as? String {
                    completionHandlerForLogoutWithUdacity(id, expiration, nil)
                }
            } else {
                completionHandlerForLogoutWithUdacity(nil, nil, error as? NSError)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func getStudentData(accountKey: String, completionHandlerForGetStudentData: @escaping (_ student: StudentInfo?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(withMethod: Constants.Methods.users, withPathExtension: "/\(accountKey)"))
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print(request)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetStudentData(nil, NSError(domain: "getStudentData", code: 1, userInfo: userInfo))
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
            
            let range = Range(5..<data.count)
            
            let newData = data.subdata(in: range)
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                sendError("JSONSerialization failed.")
            }
            
            if let studentInfoDictionary = parsedResult?[Constants.JSONResponseKeys.user] as? [String: AnyObject] {
                if let firstName = studentInfoDictionary[Constants.JSONResponseKeys.first_name] as? String, let lastName = studentInfoDictionary[Constants.JSONResponseKeys.last_name] as? String {
                    completionHandlerForGetStudentData(StudentInfo(accountKey: accountKey, firstName: firstName, lastName: lastName, mediaURL: ""), nil)
                } else {
                    completionHandlerForGetStudentData(nil, error as? NSError)
                }
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    private func udacityURLFromParameters(withMethod: String?, withPathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.UdacityAPIComponents.scheme
        components.host = Constants.UdacityAPIComponents.host
        components.path = Constants.UdacityAPIComponents.path + (withMethod ?? "") + (withPathExtension ?? "")
        
        return components.url!
    }
}

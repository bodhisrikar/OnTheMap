//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/25/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

class UdacityClient {
    static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    private struct Auth {
        static var sessionId: String = ""
        static var accountKey: String = ""
        static var registeredAccount: Bool = false
    }
    
    private struct StudentInformation {
        
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/session"
        static let allStudentsLocations = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100"
        static let studentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        case createSessionId
        case deleteSessionId
        case getAllStudentsLocations
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .createSessionId:
                return Endpoints.base
            case .deleteSessionId:
                return Endpoints.base
            case .getAllStudentsLocations:
                return Endpoints.allStudentsLocations
            case .postStudentLocation:
                return Endpoints.studentLocation
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func createSessionId(username: String, password: String, completionHandler: @escaping(Bool, Error?) -> Void) {
        var createSessionRequest = URLRequest(url: Endpoints.createSessionId.url)
        createSessionRequest.httpMethod = "POST"
        createSessionRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        createSessionRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print("Username: \(username), Password: \(password)")
        //let requestBody = SessionRequest(udacity: [username:password])
        //createSessionRequest.httpBody = try! JSONEncoder().encode(requestBody)
        createSessionRequest.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        //print("Request is : \(createSessionRequest)")
        
        let task = URLSession.shared.dataTask(with: createSessionRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(false, nil)
                }
                return
            }
            
            //print("data is \(data)")
            let newData = data.subdata(in: 5..<data.count)
            //print("New data is : \(String(data: newData, encoding: .utf8) ?? "")")
            
            do {
                let createSessionResponse = try JSONDecoder().decode(CreateSessionResponse.self, from: newData)
                //Auth.sessionId = createSessionResponse.session.sessionId
                Auth.sessionId = "6362255103S2a46a761f22011ad093f43af4371a9a1"
                //Auth.accountKey = createSessionResponse.account.accountKey
                Auth.accountKey = "699056108204"
                Auth.registeredAccount = createSessionResponse.account.registeredAccount
                //print("Session id: \(Auth.sessionId)")
                //print("Account key: \(Auth.accountKey)")
                DispatchQueue.main.async {
                    completionHandler(true, error)
                }
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(LoginErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completionHandler(false, errorResponse)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completionHandler(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getAllStudentsLocations(completionHandler: @escaping(AllStudentsLocationResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getAllStudentsLocations.url)
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            //print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let allLocationsResponse = try decoder.decode(AllStudentsLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(allLocationsResponse, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: @escaping(PostStudentLocationResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = PostStudentLocationRequest(uniqueKey: Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        request.httpBody = try! JSONEncoder().encode(requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let postStudentResponse = try decoder.decode(PostStudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(postStudentResponse, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func deleteSessionId(completionHandler: @escaping(Bool, Error?) -> Void) {
        var deleteSessionRequest = URLRequest(url: Endpoints.deleteSessionId.url)
        deleteSessionRequest.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            deleteSessionRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: deleteSessionRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
                return
            }
            
            let newData = data.subdata(in: 5..<data.count) /* subset response data! */
            //print(String(data: newData!, encoding: .utf8)!)
            
            do {
                let _ = try JSONDecoder().decode(SessionResponse.self, from: newData)
                Auth.sessionId = ""
                Auth.registeredAccount = false
                Auth.accountKey = ""
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            } catch let error {
                completionHandler(false, error)
            }
            
        }
        task.resume()
    }
}

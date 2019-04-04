//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/25/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

class UdacityClient {
    struct Auth {
        static var sessionId: String = ""
        static var accountKey: String = ""
        static var registeredAccount: Bool = false
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/session"
        static let allStudentsLocations = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100"
        static let studentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let studentName = "https://onthemap-api.udacity.com/v1/users/\(Auth.sessionId)"
        
        case createSessionId
        case deleteSessionId
        case getAllStudentsLocations
        case postStudentLocation
        case getStudentName
        
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
            case .getStudentName:
                return Endpoints.studentName
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
            
            let newData = data.subdata(in: 5..<data.count)
            
            do {
                let createSessionResponse = try JSONDecoder().decode(CreateSessionResponse.self, from: newData)
                Auth.sessionId = createSessionResponse.session.sessionId
                Auth.accountKey = createSessionResponse.account.accountKey
                Auth.registeredAccount = createSessionResponse.account.registeredAccount
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
        request.addValue(APIKeys.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(APIKeys.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
        request.addValue(APIKeys.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(APIKeys.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
    
    class func getStudentDetails() {
        var request = URLRequest(url: Endpoints.getStudentName.url)
        request.addValue(APIKeys.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(APIKeys.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            //print("Data is : \(String(data: data, encoding: .utf8)!)")
            let newData = data.subdata(in: 5..<data.count)
            //print("New Data is : \(String(data: newData, encoding: .utf8)!)")
            do {
                let json = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: Any]
                StudentDetails.firstName = "\(json["first_name"])"
                StudentDetails.lastName = "\(json["last_name"])"
            } catch let error {
                print("Error")
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

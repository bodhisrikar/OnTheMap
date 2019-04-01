//
//  PostStudentLocationRequest.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/28/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct PostStudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

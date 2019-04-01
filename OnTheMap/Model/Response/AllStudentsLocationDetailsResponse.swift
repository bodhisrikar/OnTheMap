//
//  AllStudentsLocationDetailsResponse.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/26/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct AllStudentsLocationDetailsResponse: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

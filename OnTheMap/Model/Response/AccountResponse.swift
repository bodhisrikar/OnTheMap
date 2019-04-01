//
//  AccountResponse.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/26/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct AccountResponse: Codable {
    let registeredAccount: Bool
    let accountKey: String
    
    enum CodingKeys: String, CodingKey {
        case registeredAccount = "registered"
        case accountKey = "key"
    }
}

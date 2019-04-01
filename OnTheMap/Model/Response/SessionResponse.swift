//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/25/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let sessionId: String
    let expirationDate: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expirationDate = "expiration"
    }
}

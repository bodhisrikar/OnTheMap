//
//  StudentEmailDetailsResponse.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 4/3/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct StudentEmailDetailsResponse: Codable {
    let verificationCodeSent: Bool
    let emailAddress: String
    let verifiedAccount: Bool
    
    enum CodingKeys: String, CodingKey {
        case verificationCodeSent = "_verification_code_sent"
        case emailAddress = "address"
        case verifiedAccount = "_verified"
    }
}

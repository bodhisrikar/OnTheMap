//
//  LoginErrorResponse.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/26/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct LoginErrorResponse: Codable {
    let status: Int
    let error: String
}

extension LoginErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}

//
//  CreateSessionResponse.swift
//  OnTheMap
//
//  Created by Srikar Thottempudi on 3/26/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct CreateSessionResponse: Codable {
    let account: AccountResponse
    let session: SessionResponse
}

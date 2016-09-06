//
//  UserAuthCheckRequest.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

struct UserAuthCheckRequest: APIRequestProtocol {

    typealias Response = UserResponse

    // MARK: - Private properties

    private let username: String
    private let password: String

    // MARK: - Init

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    // MARK: - Public properties

    var HTTPMethod: Method { return .POST }

    var parameters: [String: AnyObject]? {
        return [
            "username": self.username,
            "password": self.password
        ]
    }

    var path = "user-auth-check"

}

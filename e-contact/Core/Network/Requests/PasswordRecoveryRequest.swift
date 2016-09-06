//
//  PasswordRecoveryRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/20/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

struct PasswordRecoveryRequest: APIRequestProtocol {

    typealias Response = NullResponse

    // MARK: - Public properties

    var HTTPMethod: Method = .PUT
    var path = "reset-password"
    var parameters: [String : AnyObject]? {
        return [
            "email": email
        ]
    }

    // MARK: - Private properties

    private var email: String

    // MARK: - Init

    init(email: String) {
        self.email = email
    }

}

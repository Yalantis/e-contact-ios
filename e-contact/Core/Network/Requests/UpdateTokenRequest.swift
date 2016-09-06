//
//  UpdateTokenRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/19/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

struct UpdateTokenRequest: AuthorizedAPIRequestProtocol {

    typealias Response = NullResponse

    // MARK: - Public properties

    var HTTPMethod: Method = .PUT
    var path = "update-token"
    var parameters: [String : AnyObject]? {
        return [
            "push_token": pushToken,
            "device_type": "1"
        ]
    }

    // MARK: - Private properties

    private let pushToken: String!

    // MARK: - Init

    init(pushToken: String) {
        self.pushToken = pushToken
    }

}

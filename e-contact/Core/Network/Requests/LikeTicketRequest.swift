//
//  LikeTicketRequest.swift
//  e-contact
//
//  Created by Boris on 3/31/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

struct LikeTicketRequest: AuthorizedAPIRequestProtocol {

    typealias Response = UserResponse

    // MARK: - Public properties

    var path: String {
        return "ticket/\(identifier)/like"
    }
    var parameters: [String : AnyObject]? {
        return ["fb_token" : fbToken]
    }
    var HTTPMethod: Method = .PUT

    // MARK: - Private properties

    private let identifier: Int
    private let fbToken: String

    // MARK: - Init

    init(identifier: Int, fbToken: String) {
        self.fbToken = fbToken
        self.identifier = identifier
    }

}

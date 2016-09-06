//
//  ProfileRequest.swift
//  e-contact
//
//  Created by Boris on 3/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

struct ProfileRequest: AuthorizedAPIRequestProtocol {

    typealias Response = UserResponse

    // MARK: - Public properties

    var path: String {
        return "user/\(id.integerValue)"
    }
    var HTTPMethod: Method {
        if isDeleting == true {
            return .DELETE
        } else {
            return .GET
        }
    }

    // MARK: - Private properties

    private let id: NSNumber
    private let isDeleting: Bool

    // MARK: - Init

    init(id: NSNumber, isDeleting: Bool) {
        self.id = id
        self.isDeleting = isDeleting
    }

}

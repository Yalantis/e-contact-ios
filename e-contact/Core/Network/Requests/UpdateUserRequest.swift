//
//  UpdateUserRequest.swift
//  e-contact
//
//  Created by Boris on 3/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping

struct UpdateUserRequest: AuthorizedAPIRequestProtocol {

    typealias Response = UpdateUserResponse

    // MARK: - Public properties

    var HTTPMethod: Method = .PUT
    var parameters: [String : AnyObject]? {
        let mapping = SignUpUser.defaultMapping()

        if let JSONDict = FEMSerializer.serializeObject(user, usingMapping: mapping) as? [String : AnyObject] {
            return JSONDict
        }

        return nil
    }
    var path: String {
        return "user/\(id.integerValue)"
    }

    // MARK: - Private properties

    private let id: NSNumber
    private let user: SignUpUser

    // MARK: - Init

    init(id: NSNumber, user: SignUpUser) {
        self.id = id
        self.user = user
    }

}

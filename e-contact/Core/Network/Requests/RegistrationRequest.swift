//
//  RegistrationRequest.swift
//  e-contact
//
//  Created by Boris on 3/11/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping

struct RegistrationRequest: APIRequestProtocol {

    typealias Response = UserResponse

    // MARK: - Private properties

    private let user: SignUpUser

    // MARK: - Init

    init(user: SignUpUser) {
        self.user = user
    }

    // MARK: - Public properties

    var HTTPMethod: Method { return .POST }

    var parameters: [String : AnyObject]? {

        let mapping = SignUpUser.defaultMapping()

        if let JSONDict = FEMSerializer.serializeObject(user, usingMapping: mapping) as? [String : AnyObject] {
            return JSONDict
        }

        return nil
    }

    var path = "user-register"

}

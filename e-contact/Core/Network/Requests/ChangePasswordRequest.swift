//
//  ChangePasswordRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/23/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

struct PasswordsSet {

    let oldPassword: String
    let newPassword: String

}

struct ChangePasswordRequest: AuthorizedAPIRequestProtocol {

    typealias Response = NullResponse


    // MARK: - Public properties

    var HTTPMethod: Method = .PUT
    var path = "change-password"
    var parameters: [String : AnyObject]? {
        return [
            "old_password" : passwordsSet.oldPassword,
            "new_password" : passwordsSet.newPassword
        ]
    }

    // MARK: - Private properties

    private let passwordsSet: PasswordsSet!

    // MARK: - Init

    init(passwordsSet: PasswordsSet) {
        self.passwordsSet = passwordsSet
    }

}

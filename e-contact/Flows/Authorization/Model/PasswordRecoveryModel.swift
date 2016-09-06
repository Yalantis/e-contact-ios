//
//  PasswordRecoveryModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

class PasswordRecoveryModel {

    private weak var locator: ServiceLocator!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

    func recoverPassword(by email: String, success: () -> Void, failure: ResponseHandler) {
        let userService: UserService = locator.getService()

        userService.recoverPassword(on: email, success: {
                success()
            }) { error in
                failure(error)
        }
    }

}

//
//  LoginModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

final class LoginModel {

    private let userService: UserService
    private weak var locator: ServiceLocator!

    init(locator: ServiceLocator) {
        self.locator = locator
        self.userService = locator.getService()
    }

    func login(with email: String,
                    password: String,
                    success: () -> Void,
                    failure: ResponseHandler) {

        userService.login(with: email,
                          password: password,
                          success: { [weak self] loginResponse in
            if let user = loginResponse.user,
                storage: CredentialStorage = self?.locator.getService() {

                let credentials = Credentials()
                credentials.token = loginResponse.token
                credentials.id = user.identifier
                storage.userSession = credentials

                self?.registerForPushNotifications()
                success()
            }
        }) { error in
            failure(error)
        }
    }

    private func registerForPushNotifications() {
        let pushNotificationService: PushNotificationService = locator.getService()
        pushNotificationService.registerUserNotificationSettings()
    }

}

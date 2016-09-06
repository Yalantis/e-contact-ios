//
//  RegistrationModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

typealias GetSignUpUserHandler = Void -> SignUpUser


final class RegistrationModel {

    var phoneIsValid = false
    var shouldValidatePhone = false
    var getSignUpUser: GetSignUpUserHandler!
    private let userService: UserService

    private(set) var user = SignUpUser()
    private(set) weak var locator: ServiceLocator!

    init(locator: ServiceLocator) {
        self.locator = locator
        self.userService = locator.getService()
    }


    func validatePhone(success: () -> Void, failure: ResponseHandler) {
        self.user = getSignUpUser()
        userService.validatePhone(with: user, success: { [weak self]response in
            self?.phoneIsValid = true
            success()
        }, failure: { [weak self] response in
            if response.message == Constants.Networking.PhoneError {
                self?.phoneIsValid = false
                failure(response)
            } else if response.statusCode.isRequestErrorCode {
                self?.phoneIsValid = true
                success()
            }
        })
    }

    private func validateUser(successHandler: () -> Void, failure: ResponseHandler) {
        self.user = getSignUpUser()
        userService.validateUser(user, success: {
                successHandler()
            }, failure: failure)
    }

    // MARK: - Registration requests

    func executeRegistration(success: () -> Void, failure: ResponseHandler) {
        validateUser({ [unowned self] in
            self.userService.registerUser(self.user,
                success: { [weak self] user, token in
                    guard let storage: CredentialStorage = self?.locator.getService() else {
                        return
                    }
                    let credentials = Credentials()
                    credentials.token = token
                    credentials.id = user.identifier
                    storage.userSession = credentials

                    self?.registerForPushNotifications()
                    success()
                }, failure: failure)
            }, failure: failure)

    }

    private func registerForPushNotifications() {
        let pushNotificationService: PushNotificationService = locator.getService()
        pushNotificationService.registerUserNotificationSettings()
    }

}

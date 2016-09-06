//
//  UserService.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import Alamofire

final class UserService {

    private unowned let apiClient: RestAPIClient

    init(apiClient: RestAPIClient) {
        self.apiClient = apiClient
    }

    func login(with email: String, password: String, success: UserResponse -> Void, failure: ResponseHandler) {
        let request = UserAuthCheckRequest(username: email, password: password)

        apiClient.executeRequest(request, success: success, failure: failure)
    }

    func validatePhone(with user: SignUpUser, success: () -> Void, failure: ResponseHandler) {
        let request = ValidateUserRequest(user: user)

        apiClient.executeRequest(request, success: { response in
            success()
            }, failure: failure)
    }

    func registerUser(user: SignUpUser, success: (User, String) -> Void, failure: ResponseHandler) {
        let request = RegistrationRequest(user: user)

        apiClient.executeRequest(request, success: { response in
            if let user = response.user, token = response.token {
                success(user, token)
            }
            }, failure: failure)
    }

    func validateUser(user: SignUpUser, success: () -> Void, failure: ResponseHandler) {
        let request = ValidateUserRequest(user: user)

        apiClient.executeRequest(request, success: { response in
                success()
            }, failure: failure)
    }

    func recoverPassword(on email: String, success: () -> Void, failure: ResponseHandler) {
        let request = PasswordRecoveryRequest(email: email)

        apiClient.executeRequest(request, success: { response in
                success()
            }, failure: failure)
    }

}

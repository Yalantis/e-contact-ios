//
//  ErrorResponse.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/14/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping

enum ValidationAttributesKey: String {

    case Phone = "phone"
    case Email = "email"

}

class ErrorResponse {

    //MARK: - Public properties

    var statusCode: StatusCode = .OK
    var message = ""

    //MARK: - Init

    init(statusCode: StatusCode, message: String, attributes: [String:AnyObject]? = nil) {

        self.statusCode = statusCode
        switch self.statusCode {
        case .NoInternetConnection:
            self.message = "network.error.no_internet_connection".localized()

        case .BadCredentials:
            self.message = "network.error.bad_credentials".localized()

        case .UnprocessableEntity:
            self.message = parseUnprocessableEntityError(with: attributes)

        case .InternetConnectionWasLost:
            self.message = "network.error.internet_connection_was_lost".localized()

        case .ObjectNotFound:
            self.message = "network.error.session_expired".localized()

        case .AccessForbidden:
            self.message = "network.error.access_forbidden".localized()

        case .RequestTimeout:
            self.message = "network.error.request_timeout".localized()

        case .ServerCouldNotBeFound:
            self.message = "network.error.server_could_not_be_found".localized()

        case .LimitedRequest:
            self.message = "network.error.limited_request".localized()

        default:
            self.message = message

        }
    }

    // MARK: - Static methods

    static func parseError(JSON: AnyObject) -> ErrorResponse {
        guard let errorJSON = JSON as? [String:AnyObject],
            code = errorJSON["code"] as? Int,
            message = (errorJSON["message"])! as? String  else {
                return ErrorResponse(statusCode: .BadRequest, message: "network.error.unknow_error".localized())
        }
        guard let attributes  = (errorJSON["attributes"]) as? [String:AnyObject] where
            code == StatusCode.UnprocessableEntity.rawValue  else {
                return ErrorResponse(statusCode: StatusCode(rawValue: code) ?? .BadRequest, message: message)
        }

        return ErrorResponse(
            statusCode: StatusCode(rawValue: code) ?? .BadRequest, message: message, attributes: attributes
        )
    }

    // MARK: - Private methods

    private func parseUnprocessableEntityError(with attributes: [String : AnyObject]?) -> String {
        if let message = message(for: ValidationAttributesKey.Phone, attributes: attributes) {
            return message
        }
        if let message = message(for: ValidationAttributesKey.Email, attributes: attributes) {
            return message
        }

        return "network.error.unknow_error".localized()
    }

    private func message(for key: ValidationAttributesKey, attributes: [String : AnyObject]?) -> String? {
        if let attribute = attributes?[key.rawValue],
            message = attribute[0]["message"]  as? String where
            message == Constants.Networking.UsedValueError {

            return String(format: "network.error.already_used_value".localized(), key.localized())
        }

        return nil
    }

}

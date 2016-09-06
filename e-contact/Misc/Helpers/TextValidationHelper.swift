//
//  TextValidationHelper.swift
//  e-contact
//
//  Created by Illya on 3/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class TextValidationHelper {

    static func validatePasswords(oldPasswordText: String?, newPasswordText: String?) -> Bool {
        guard let oldPassword = oldPasswordText,
            newPassword = newPasswordText where oldPassword != newPassword else {
                AlertManager.sharedInstance.showSimpleAlert("changePassword.alert.confirm_password".localized())
                return false
        }

        return true
    }

   static func validateText(string: String?, parameters: ValidationParameters, withAlert: Bool = true) -> Bool {
        let message: String? = withAlert ? parameters.message : nil

        return validateText(string, regExp: parameters.regExp, message: message)
    }

   static func validateText(string: String?, regExp: String, message: String?) -> Bool {
        if string?.characters.count > 0 {
            let predicate = NSPredicate(format:"SELF MATCHES %@", regExp)
            let result = predicate.evaluateWithObject(string)

            if let message = message where result == false {
                AlertManager.sharedInstance.showSimpleAlert(message)
            }

            return result
        } else {

            return false
        }
    }

   static func validateText(text: String?, notEqual placeHolder: String? = nil, message: String) -> Bool {
        guard let text = text where !text.isEmpty else {
            AlertManager.sharedInstance.showSimpleAlert(message)

            return false
        }
        if let placeHolder = placeHolder where text == placeHolder {
            AlertManager.sharedInstance.showSimpleAlert(message)

            return false
        }

        return true
    }

}

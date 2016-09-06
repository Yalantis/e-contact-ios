//
//  ValidationParameters.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/23/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

protocol ValidationParameters {
    var message: String { get }
    var regExp: String { get }
}

struct ValidationParametersSet {
    struct Email: ValidationParameters {
        var regExp = Constants.Regexp.EmailRegExp
        var message = "registration.error.email_validation".localized()
    }
    struct Password: ValidationParameters {
        var regExp = "^.{4,20}$"
        var message = "registration.error.password_validation".localized()
    }
    struct LastName: ValidationParameters {
        var regExp = "^.{4,30}$"
        var message = "registration.error.last_name_validation".localized()
    }
    struct FirstName: ValidationParameters {
        var regExp = "^.{3,30}$"
        var message = "registration.error.first_name_validation".localized()
    }
    struct MiddleName: ValidationParameters {
        var regExp = "^.{4,30}$"
        var message = "registration.error.middle_name_validation".localized()
    }
    struct PhoneNumber: ValidationParameters {
        var regExp = "^.{10,18}$"
        var message = "registration.error.phone_validation".localized()
    }
    struct Address: ValidationParameters {
        var regExp = ".+"
        var message = "registration.error.empty_address".localized()
    }
    struct None: ValidationParameters {
        var regExp = ".+"
        var message = "Please Enter Validation Error Message"
    }
}

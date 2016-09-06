//
//  SignUpUser.swift
//  e-contact
//
//  Created by Boris on 3/11/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping

class SignUpUser: NSObject {

    var firstName: String?
    var lastName: String?
    var middleName: String?
    var email: String?
    var password: String?
    var registrationAddress: LocalAddress?
    var phone: String?

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping.addAttributesFromDictionary([
            "email": "email",
            "password": "password",
            "firstName": "first_name",
            "middleName": "middle_name",
            "lastName": "last_name",
            "phone": "phone"
        ])

        let relationship = FEMRelationship(property: "registrationAddress", keyPath: "address",
            mapping: LocalAddress.defaultMapping())
        mapping.addRelationship(relationship)

        return mapping
    }

}

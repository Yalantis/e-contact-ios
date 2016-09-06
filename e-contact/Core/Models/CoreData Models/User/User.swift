//
//  User.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping

class User: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "User")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "email": "email",
            "fbRegistered":"fb_registered",
            "firstName":"first_name",
            "identifier":"id",
            "imageURL":"image",
            "lastName":"last_name",
            "middleName":"middle_name",
            "phone":"phone"
        ])

        let attribute = FEMAttribute(property: "birthDate",
                                     keyPath: "birthday",
                                     map: Constants.Mapping.NumberToDateMapper) { (value) -> AnyObject? in
                                        if let date = value as? NSDate {
                                            return NSNumber(double: date.timeIntervalSince1970)
                                        }
                                        return nil
        }

        mapping.addAttribute(attribute)

        let relationship = FEMRelationship(property: "address", keyPath: "address", mapping: Address.defaultMapping())
        mapping.addRelationship(relationship)

        return mapping
    }

    static func currentUser() -> User? {
        if let userId = CredentialStorage.defaultCredentialStorage().userSession?.id,
            user = User.MR_findFirstByAttribute("identifier", withValue: userId) {
            return user
        }

        return nil
    }

    static func removeCurrentUser() {
        let user = User.currentUser()

        CredentialStorage.defaultCredentialStorage().removeCredentialForKey(CredentialStorage.Key.UserSession)
        user?.MR_deleteEntity()
    }

}

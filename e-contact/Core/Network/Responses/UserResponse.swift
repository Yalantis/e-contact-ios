//
//  UserResponse.swift
//  e-contact
//
//  Created by Boris on 3/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping
import MagicalRecord

class UserResponse: ResponseProtocol {

    // MARK: - Public properties

    var user: User?
    var token: String?

    // MARK: - Initializer

    required init (JSON: AnyObject) {
        let context = NSManagedObjectContext.MR_defaultContext()

        if let JSONDict = JSON as? [NSObject : AnyObject],
            userJSONDict = JSONDict["user"] as? [NSObject : AnyObject],
            userObj = FEMDeserializer.objectFromRepresentation(
                userJSONDict, mapping: User.defaultMapping(),
                context: context
                ) as? User,
            tokenString = JSONDict["token"] as? String {
            token = tokenString
            user = userObj
            context.MR_saveToPersistentStoreAndWait()
        }
    }

}

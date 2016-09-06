//
//  UpdateUserResponse.swift
//  e-contact
//
//  Created by Boris on 3/29/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping
import MagicalRecord

class UpdateUserResponse: ResponseProtocol {

    // MARK: - Public properties

    var user: User?

    // MARK: - Initializer

    required init (JSON: AnyObject) {
        let context = NSManagedObjectContext.MR_defaultContext()

        if let userJSONDict = JSON as?  NSDictionary,
            userObj = FEMDeserializer.objectFromRepresentation(userJSONDict as [NSObject : AnyObject], mapping:
                User.defaultMapping(), context: context) as? User {

            user = userObj
            context.MR_saveToPersistentStoreAndWait()
        }
    }

}

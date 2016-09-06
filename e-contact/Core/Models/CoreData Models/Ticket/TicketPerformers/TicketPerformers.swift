//
//  TicketPerformers.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/21/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

class TicketPerformers: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketPerformers")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "organization" : "organization",
            "identifier" : "id"
        ])

        return mapping
    }

}

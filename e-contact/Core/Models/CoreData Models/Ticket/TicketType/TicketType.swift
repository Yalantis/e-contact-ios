//
//  TicketType.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping

class TicketType: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketType")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "name": "name",
            "identifier":"id"
            ])

        return mapping
    }

}

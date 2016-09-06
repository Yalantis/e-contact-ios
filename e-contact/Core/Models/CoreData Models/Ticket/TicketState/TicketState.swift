//
//  TicketState.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping


class TicketState: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketState")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "name": "name",
            "identifier":"id"
            ])

        return mapping
    }

}

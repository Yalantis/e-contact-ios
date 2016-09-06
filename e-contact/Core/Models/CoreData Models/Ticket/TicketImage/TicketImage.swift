//
//  TicketImage.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping

class TicketImage: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketImage")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "identifier" : "id",
            "imageName" : "filename"
            ])

        return mapping
    }

}

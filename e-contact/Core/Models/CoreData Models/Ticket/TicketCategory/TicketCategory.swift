//
//  TicketCategory.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping
import DataSource

class TicketCategory: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketCategory")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "name" : "name",
            "identifier" : "id",
            "imageName" : "image"
        ])

        return mapping
    }

    static func imagesMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketCategory")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "name" : "name",
            "identifier" : "id"
            ])

        mapping.addRelationshipMapping(CategoryImage.defaultMapping(), forProperty: "image", keyPath: "images")

        return mapping
    }

}

class TicketCategoryToCellMapper: ObjectMappable {

    var cellIdentifier: String {
        get {
            return "TicketCategoryCell"
        }
    }

    func supportsObject(object: Any) -> Bool {
        return true
    }

    func mapObject(object: Any, toCell cell: Any, atIndexPath: NSIndexPath) {
        guard let tableViewCell = cell as? TicketCategoryCell, name = (object as? TicketCategory)?.name else {
            return
        }

        tableViewCell.labelTitle?.text = name
    }

}

    //Class for transporting purposes
class TicketCategoryWrapper: NSObject {

    var categories = [TicketCategory]()
    var isEmpty: Bool {
        return categories.isEmpty
    }

    func clear() {
        categories = [TicketCategory]()
    }

}

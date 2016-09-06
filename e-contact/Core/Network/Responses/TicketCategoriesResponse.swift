//
//  TicketCategoriesResponse.swift
//  e-contact
//
//  Created by Boris on 3/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping
import MagicalRecord

class TicketCategoriesResponse: ResponseProtocol {

    // MARK: - Public properties

    var categories: [TicketCategory]?
    var version: Int?

    // MARK: - Initializer

    required init (JSON: AnyObject) {
        guard let JSONDict = JSON as? [String: AnyObject],
            categoryesDict = JSONDict["categories"] as? [AnyObject],
            version = JSONDict["version"] as? Int,
            categoriesObj = FEMDeserializer.collectionFromRepresentation(
                categoryesDict,
                mapping: TicketCategory.imagesMapping(),
                context:  NSManagedObjectContext.MR_defaultContext()) as? [TicketCategory] else {
            return
        }

        categories = categoriesObj
        self.version = version
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

}

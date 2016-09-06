//
//  TicketsResponse.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping
import MagicalRecord

class TicketsResponse: ResponseProtocol {

    // MARK: - Public properties

    var tickets: [Ticket]?

    // MARK: - Initializer

    required init (JSON: AnyObject) {
        let context = NSManagedObjectContext.MR_defaultContext()

        if let JSONDict = JSON as? [AnyObject],
            tickets = FEMDeserializer.collectionFromRepresentation(
                JSONDict,
                mapping: Ticket.defaultMapping(),
                context: context
                ) as? [Ticket] {
            self.tickets = tickets
            context.MR_saveToPersistentStoreAndWait()
        }
    }

}

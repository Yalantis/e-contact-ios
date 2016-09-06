//
//  TicketResponse.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping
import MagicalRecord

class TicketResponse: ResponseProtocol {

    // MARK: - Public properties

    var ticket: Ticket?

    // MARK: - Initializer

    required init (JSON: AnyObject) {
        let context = NSManagedObjectContext.MR_defaultContext()

        if let JSONDict = JSON as? [NSObject : AnyObject],
            ticket = FEMDeserializer.objectFromRepresentation(JSONDict,
                                                              mapping: Ticket.defaultMapping(),
                                                              context: context) as? Ticket {
            self.ticket = ticket
            context.MR_saveToPersistentStoreAndWait()
        }
    }

}

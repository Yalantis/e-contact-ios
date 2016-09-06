//
//  TicketImage+CoreDataProperties.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TicketImage {

    @NSManaged var identifier: NSNumber?
    @NSManaged var imageName: String?
    @NSManaged var path: String?
    @NSManaged var tickets: NSSet?

    @NSManaged func addTicketsObject(value: Ticket)
    @NSManaged func removeTicketsObject(value: Ticket)
    @NSManaged func addTickets(value: Set<Ticket>)
    @NSManaged func removeTickets(value: Set<Ticket>)

}

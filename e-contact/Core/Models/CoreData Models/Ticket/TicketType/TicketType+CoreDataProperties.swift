//
//  TicketType+CoreDataProperties.swift
//
//
//  Created by Boris on 3/10/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TicketType {

    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var tickets: NSSet?

}

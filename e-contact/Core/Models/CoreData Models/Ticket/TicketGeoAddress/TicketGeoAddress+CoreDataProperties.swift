//
//  TicketGeoAddress+CoreDataProperties.swift
//  e-contact
//
//  Created by Illya on 4/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TicketGeoAddress {

    @NSManaged var identifier: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var tickets: NSSet?

}

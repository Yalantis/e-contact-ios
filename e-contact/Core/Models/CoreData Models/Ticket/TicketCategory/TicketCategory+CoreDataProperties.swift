//
//  TicketCategory+CoreDataProperties.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TicketCategory {

    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var imageName: String?
    @NSManaged var tickets: NSSet?
    @NSManaged var image: CategoryImage?

}

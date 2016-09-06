//
//  Address+CoreDataProperties.swift
//  e-contact
//
//  Created by Illya on 3/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Address {

    @NSManaged var cityId: NSNumber?
    @NSManaged var cityName: String?
    @NSManaged var districtId: NSNumber?
    @NSManaged var districtName: String?
    @NSManaged var flat: String?
    @NSManaged var houseId: NSNumber?
    @NSManaged var houseName: String?
    @NSManaged var identifier: NSNumber?
    @NSManaged var streetId: NSNumber?
    @NSManaged var streetName: String?
    @NSManaged var streetType: String?
    @NSManaged var users: NSSet?
    @NSManaged var tickets: NSSet?

}

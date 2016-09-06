//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var birthDate: NSDate?
    @NSManaged var email: String?
    @NSManaged var fbRegistered: NSNumber?
    @NSManaged var firstName: String?
    @NSManaged var identifier: NSNumber?
    @NSManaged var imageURL: String?
    @NSManaged var lastName: String?
    @NSManaged var middleName: String?
    @NSManaged var phone: String?
    @NSManaged var address: Address?
    @NSManaged var tickets: NSSet?

}

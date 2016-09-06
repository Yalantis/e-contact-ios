//
//  CategoryImage+CoreDataProperties.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/20/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CategoryImage {

    @NSManaged var highResolution: String?
    @NSManaged var lowResolution: String?
    @NSManaged var mediumResolution: String?
    @NSManaged var categories: NSSet?

}

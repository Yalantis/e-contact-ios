//
//  Ticket+CoreDataProperties.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/14/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ticket {

    @NSManaged var body: String?
    @NSManaged var comment: String?
    @NSManaged var createdDate: NSDate?
    @NSManaged var deadline: NSDate?
    @NSManaged var identifier: NSNumber?
    @NSManaged var likesCounter: NSNumber?
    @NSManaged var localIdentifier: NSNumber?
    @NSManaged var startedDate: NSDate?
    @NSManaged var ticketId: String?
    @NSManaged var title: String?
    @NSManaged var completedDate: NSDate?
    @NSManaged var answers: NSSet?
    @NSManaged var category: TicketCategory?
    @NSManaged var geoAddress: TicketGeoAddress?
    @NSManaged var images: NSSet?
    @NSManaged var performers: NSSet?
    @NSManaged var state: TicketState?
    @NSManaged var ticketAddress: Address?
    @NSManaged var type: TicketType?
    @NSManaged var user: User?

    @NSManaged func addAnswersObject(value: TicketAnswer)
    @NSManaged func removeAnswersObject(value: TicketAnswer)
    @NSManaged func addAnswers(value: Set<TicketAnswer>)
    @NSManaged func removeAnswers(value: Set<TicketAnswer>)

    @NSManaged func addImagesObject(value: TicketImage)
    @NSManaged func removeImagesObject(value: TicketImage)
    @NSManaged func addImages(value: Set<TicketImage>)
    @NSManaged func removeImages(value: Set<TicketImage>)

    @NSManaged func addPerformersObject(value: TicketPerformers)
    @NSManaged func removePerformersObject(value: TicketPerformers)
    @NSManaged func addPerformers(value: Set<TicketPerformers>)
    @NSManaged func removePerformers(value: Set<TicketPerformers>)

}

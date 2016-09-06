//
//  Ticket.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping
import MagicalRecord

class Ticket: NSManagedObject {

    // MARK: Computed property

    var performersString: String? {
        guard let performersArray = performers?.allObjects as? [TicketPerformers] where !performersArray.isEmpty else {
            return nil
        }
        var result = ""

        for performer in performersArray where performer.organization != nil {
            result.appendContentsOf(String(format:  performer.organization! + ";" + Constants.Whitespace))
        }
        return result
    }

    var imagesPaths: [String]? {
        guard let imagesDataArray = images?.allObjects as? [TicketImage] else {
            return nil
        }
        var imagePaths = [String]()
        imagePaths.reserveCapacity(imagesDataArray.count)

        for imageData in imagesDataArray {
            if let imagePath = imageData.imageName?.imagePathPrefix() {
                imagePaths.append(imagePath)
            }
        }

        return imagePaths
    }

    // MARK: Class methods

    static func defaultMapping() -> FEMMapping {

        let mapping = FEMMapping(entityName: "Ticket")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "title": "title",
            "likesCounter" : "likes_counter",
            "identifier" : "id",
            "body" : "body",
            "ticketId" : "ticket_id",
            "comment" : "comment"
        ])

        addDateMapping(mapping)
        mapping.addToManyRelationshipMapping(TicketPerformers.defaultMapping(),
                                             forProperty: "performers",
                                             keyPath: "performers")
        mapping.addRelationshipMapping(TicketGeoAddress.defaultMapping(),
                                       forProperty: "geoAddress",
                                       keyPath: "geo_address")
        mapping.addRelationshipMapping(TicketCategory.defaultMapping(),
                                       forProperty: "category",
                                       keyPath: "category")
        mapping.addRelationshipMapping(TicketState.defaultMapping(),
                                       forProperty: "state",
                                       keyPath: "state")
        mapping.addRelationshipMapping(TicketType.defaultMapping(),
                                       forProperty: "type",
                                       keyPath: "type")
        mapping.addRelationshipMapping(User.defaultMapping(),
                                       forProperty: "user",
                                       keyPath: "user")
        mapping.addRelationshipMapping(Address.defaultMapping(),
                                       forProperty: "ticketAddress",
                                       keyPath: "address")
        mapping.addToManyRelationshipMapping(TicketImage.defaultMapping(),
                                             forProperty: "images",
                                             keyPath: "files")
        mapping.addToManyRelationshipMapping(TicketAnswer.defaultMapping(),
                                             forProperty: "answers",
                                             keyPath: "answers")

        return mapping
    }

    private static func addDateMapping(mapping: FEMMapping) {
        let createDateAttribute = FEMAttribute(
            property: "createdDate",
            keyPath: "created_date",
            map: Constants.Mapping.NumberToDateMapper ,
            reverseMap: nil
        )
        mapping.addAttribute(createDateAttribute)

        let registeredDateAttribute = FEMAttribute(
            property: "startedDate",
            keyPath: "start_date",
            map: Constants.Mapping.NumberToDateMapper ,
            reverseMap: nil
        )
        mapping.addAttribute(registeredDateAttribute)

        let deadlineDateAttribute = FEMAttribute(
            property: "deadline",
            keyPath: "deadline",
            map: Constants.Mapping.NumberToDateMapper ,
            reverseMap: nil
        )
        mapping.addAttribute(deadlineDateAttribute)

        let completedDateAttribute = FEMAttribute(
            property: "completedDate",
            keyPath: "completed_date",
            map: Constants.Mapping.NumberToDateMapper ,
            reverseMap: nil
        )
        mapping.addAttribute(completedDateAttribute)
    }

    static func representationMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping.addAttributesFromDictionary([
            "title" : "title",
            "ticketId" : "ticket_id",
            "body" : "body"
            ])

        mapping.addRelationshipMapping(
            TicketGeoAddress.defaultMapping(),
            forProperty: "geoAddress",
            keyPath: "geo_address"
        )
        mapping.addRelationshipMapping(
            TicketCategory.defaultMapping(),
            forProperty: "category",
            keyPath: "category"
        )
        mapping.addRelationshipMapping(
            TicketState.defaultMapping(),
            forProperty: "state",
            keyPath: "state"
        )
        mapping.addRelationshipMapping(
            TicketType.defaultMapping(),
            forProperty: "type",
            keyPath: "type"
        )
        mapping.addRelationshipMapping(
            User.defaultMapping(),
            forProperty: "user",
            keyPath: "user"
        )
        mapping.addRelationshipMapping(
            Address.defaultMapping(),
            forProperty: "ticketAddress",
            keyPath: "address"
        )

        return mapping
    }

    // MARK: Public methods

    func replaceImagesSetWithArray(array: [String]) {
        images = nil
        for path in array {
            let ticketImage = TicketImage.MR_createEntity()!
            ticketImage.path = path
            addImagesObject(ticketImage)
        }

    }

    // Only for local images urls
    func fetchCachedImagesPath() -> [String]? {
        guard let imagesDataArray = images?.allObjects as? [TicketImage] else {
            return nil
        }
        var imagePaths = [String]()
        imagePaths.reserveCapacity(imagesDataArray.count)

        for imageData in imagesDataArray {
            if let imagePath = imageData.path {
                imagePaths.append(imagePath)
            }
        }
        return imagePaths
    }

}

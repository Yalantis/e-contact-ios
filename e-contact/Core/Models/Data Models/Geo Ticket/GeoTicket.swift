//
//  GeoTicket.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping
import CoreLocation

class GeoTicket {

    let geoPoint: CLLocationCoordinate2D
    let identifier: Int
    let stateIdentifier: Int
    let categoryIdentifier: Int

    init(latitude: Double, longitude: Double, identifier: Int, stateIdentifier: Int, categoryIdentifier: Int) {
        self.identifier = identifier
        self.stateIdentifier = stateIdentifier
        self.categoryIdentifier = categoryIdentifier
        self.geoPoint = CLLocationCoordinate2DMake(latitude, longitude)
    }

}

// MARK: - Mapping

extension GeoTicket {

    static func collectionOfObjectsFromRepresentation(JSON: Any) -> [GeoTicket]? {
        guard let JSONDict = JSON as? [AnyObject] else {
            return nil
        }
        var geoTickets = [GeoTicket]()

        for object in JSONDict {
            if let geoTicket =  objectfromRepresentation(object) {
                geoTickets.append(geoTicket)
            }
        }

        return geoTickets
    }

    static func objectfromRepresentation(rawObject: Any) -> GeoTicket? {
        guard let object = rawObject as? [String :AnyObject],
            longitudeString = object["longitude"] as? String,
            categoryIdentifier = object["category"] as? Int,
            latitudeString = object["latitude"] as? String,
            stateIdentifier = object["state"] as? Int,
            identifier = object["id"] as? Int,
            longitude = Double(longitudeString),
            latitude = Double(latitudeString) else {
            return nil
        }

        let geoTicket = GeoTicket(latitude: latitude,
                                  longitude: longitude,
                                  identifier: identifier,
                                  stateIdentifier: stateIdentifier,
                                  categoryIdentifier: categoryIdentifier)

        return geoTicket
    }

}

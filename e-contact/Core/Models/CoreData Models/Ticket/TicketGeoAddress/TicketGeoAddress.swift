//
//  TicketGeoAddress.swift
//  e-contact
//
//  Created by Illya on 4/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping
import GoogleMaps
import CoreLocation

class TicketGeoAddress: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketGeoAddress")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "identifier":"id",
            "name": "address"
        ])

        let mapBlock: FEMMapBlock = { value -> AnyObject? in
            guard let value = value as? NSString else {
                return nil
            }

            return value.doubleValue
        }
        let reverseMapBlock: FEMMapBlock = { value -> AnyObject? in
            guard let value = value as? NSNumber where value != 0 else {
                return nil
            }

            return value
        }

        let latitudeAttribute: FEMAttribute = FEMAttribute(property: "latitude",
                                                           keyPath: "latitude",
                                                           map: mapBlock,
                                                           reverseMap: reverseMapBlock)


        let longitudeAttribute: FEMAttribute = FEMAttribute(property: "longitude",
                                                            keyPath: "longitude",
                                                            map: mapBlock,
                                                            reverseMap: reverseMapBlock)

        mapping.addAttribute(longitudeAttribute)
        mapping.addAttribute(latitudeAttribute)

        return mapping
    }

    static func createEntityWithPlace(place: GMSPlace) -> TicketGeoAddress? {
        guard let geoAddress = TicketGeoAddress.MR_createEntity() else {
            return nil
        }
        geoAddress.latitude = place.coordinate.latitude
        geoAddress.longitude = place.coordinate.longitude
        if let formattedAddress = place.formattedAddress {
            geoAddress.name = formattedAddress
        } else {
            geoAddress.name = "geoAddress.string.latitude".localized() + " " + geoAddress.latitude!.stringValue + " " +
                "geoAddress.string.longitude".localized() + " " + geoAddress.longitude!.stringValue
        }

        geoAddress.identifier = 0

        return geoAddress
    }

    static func createEntityWithAddressString(address: String) -> TicketGeoAddress? {
        guard let geoAddress = TicketGeoAddress.MR_createEntity() else {
            return nil
        }
        geoAddress.name = address
        geoAddress.identifier = 0

        return geoAddress
    }

}

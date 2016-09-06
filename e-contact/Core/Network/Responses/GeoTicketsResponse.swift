//
//  GeoTicketsResponse.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping
import MagicalRecord
import CoreLocation

class GeoTicketsResponse: ResponseProtocol {

    // MARK: - Public properties

    var geoTickets = [GeoTicket]()

    // MARK: - Initializer

    required init (JSON: AnyObject) {

        if let tickets = GeoTicket.collectionOfObjectsFromRepresentation(JSON) {
            geoTickets = tickets
        }

    }


}

//
//  GeoTicketsSorter.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import CoreLocation

struct GeoTicketsSorter {

    static func sort(geoTickets: [GeoTicket]) -> [GeoTicket] {
        var minDistance = Double(Int.max)
        var minDistanceItemIndex = 0

        for index in geoTickets.indices {
            let candidateForMinDistance = geoTickets[index].geoPoint.distanceToPoint(CLLocationCoordinate2DMake(0, 0))
            if minDistance > candidateForMinDistance {
                minDistance = candidateForMinDistance
                minDistanceItemIndex = index
            }
        }

        let starterGeoPoint = geoTickets[minDistanceItemIndex].geoPoint

        return geoTickets.sort { geoA, geoB -> Bool in
            return geoA.geoPoint.distanceToPoint(starterGeoPoint) < geoB.geoPoint.distanceToPoint(starterGeoPoint)
        }
    }

}

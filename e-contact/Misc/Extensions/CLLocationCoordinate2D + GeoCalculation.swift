//
//  CLLocationCoordinate2D + GeoCalculation.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import CoreLocation


enum ClassifyResults {

    case Left, Inessential

}

extension CLLocationCoordinate2D {


    func distanceToPoint(point: CLLocationCoordinate2D) -> Double {
        return sqrt(pow(point.latitude - latitude, 2) + pow(point.longitude - longitude, 2))
    }

    func classifyToEdge(edge: Edge) -> ClassifyResults {
        let aPoint = edge.destination.minus(edge.origin)
        let bPoint = self.minus(edge.origin)
        let orientation = aPoint.latitude * bPoint.longitude - bPoint.latitude * aPoint.longitude

        return (orientation > 0) ? .Left : .Inessential
    }

    func minus(point: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude - point.latitude, longitude: longitude - point.longitude)
    }

    static func midlePointOfClusterContent(cluster: [GeoTicket]) -> CLLocationCoordinate2D {
        var point = CLLocationCoordinate2D()
        for element in cluster {
            point.latitude = point.latitude + element.geoPoint.latitude
            point.longitude = point.longitude + element.geoPoint.longitude
        }
        point.latitude =  point.latitude / Double(cluster.count)
        point.longitude = point.longitude / Double(cluster.count)

        return point
    }

}

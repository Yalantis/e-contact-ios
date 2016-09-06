//
//  GMSVisibleRegion+EvaluatedRect.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/25/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import GoogleMaps

struct Edge {

    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D

    init (origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D ) {
        self.origin = origin
        self.destination = destination
    }

}

extension GMSVisibleRegion {

    func isIncludePoint(point: CLLocationCoordinate2D) -> Bool {

        return point.classifyToEdge(leftEdge) != .Left &&
            point.classifyToEdge(topEdge) != .Left &&
            point.classifyToEdge(rightEdge) != .Left &&
            point.classifyToEdge(bottomEdge) != .Left
    }

    var evaluatedNearLeft: CLLocationCoordinate2D {
        let latitudeDifference = farLeft.latitude - nearLeft.latitude
        let longitudeDifference = nearRight.longitude - nearLeft.longitude

        return CLLocationCoordinate2D(
            latitude: nearLeft.latitude - latitudeDifference / Constants.VisibleRegion.HeightDivider,
            longitude: nearLeft.longitude - longitudeDifference / Constants.VisibleRegion.WidthDivider
        )
    }

    var evaluatedNearRight: CLLocationCoordinate2D {
        let latitudeDifference = farRight.latitude - nearRight.latitude
        let longitudeDifference = nearRight.longitude - nearLeft.longitude

        return CLLocationCoordinate2D(
            latitude: nearRight.latitude - latitudeDifference / Constants.VisibleRegion.HeightDivider,
            longitude: nearRight.longitude + longitudeDifference / Constants.VisibleRegion.WidthDivider
        )
    }

    var evaluatedFarRight: CLLocationCoordinate2D {
        let latitudeDifference = farRight.latitude - nearRight.latitude
        let longitudeDifference = farRight.longitude - farLeft.longitude

        return CLLocationCoordinate2D(
            latitude: farRight.latitude + latitudeDifference / Constants.VisibleRegion.HeightDivider,
            longitude: farRight.longitude + longitudeDifference / Constants.VisibleRegion.WidthDivider
        )
    }

    var evaluatedFarLeft: CLLocationCoordinate2D {
        let latitudeDifference = farLeft.latitude - nearLeft.latitude
        let longitudeDifference = farRight.longitude - farLeft.longitude

        return CLLocationCoordinate2D(
            latitude: farLeft.latitude + latitudeDifference / Constants.VisibleRegion.HeightDivider,
            longitude: farLeft.longitude - longitudeDifference / Constants.VisibleRegion.WidthDivider
        )
    }

    var leftEdge: Edge {
        return Edge(origin: evaluatedNearLeft, destination: evaluatedNearRight)
    }
    var topEdge: Edge {
        return Edge(origin: evaluatedNearRight, destination: evaluatedFarRight)
    }
    var rightEdge: Edge {
        return Edge(origin: evaluatedFarRight, destination: evaluatedFarLeft)
    }
    var bottomEdge: Edge {
        return Edge(origin: evaluatedFarLeft, destination: evaluatedNearLeft)
    }

}

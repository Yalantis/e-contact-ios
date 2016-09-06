//
//  ClusterizationHelper.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import GoogleMaps

struct ClusterizationHelper {

    static func clusterize(tickets: [GeoTicket], clusterRadius: Double) -> [Cluster] {
        if tickets.isEmpty {
            return [Cluster]()
        }
        var tickets = tickets
        var clusters = [Cluster]()

        clusters.append(Cluster(elements: [tickets.removeLast()]))

        outerLoop: for element in tickets {

            for cluster in clusters {
                let distanceToPoint = cluster.elements.first!.geoPoint.distanceToPoint(element.geoPoint)

                if distanceToPoint < clusterRadius {
                    cluster.append(element)
                    continue outerLoop
                }
            }

            let cluster = Cluster(elements: [element])
            clusters.append(cluster)
        }

        return clusters
    }

}

//
//  Cluster.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation


class Cluster {

    private(set) var elements: [GeoTicket]

    init(elements: [GeoTicket]) {
        self.elements = elements
    }

    func append(element: GeoTicket) {
        elements.append(element)
    }

}

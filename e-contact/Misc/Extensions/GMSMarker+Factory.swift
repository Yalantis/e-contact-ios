//
//  GMSMarker+Factory.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/19/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import GoogleMaps

enum TicketStateId: Int {

    case Moderation = 1, Denied, Accepted, OnReview, InWork, Done

}

extension GMSMarker {

    convenience init(ticket: GeoTicket) {
        self.init(position: ticket.geoPoint)
        guard let ticketState = TicketStateId(rawValue: ticket.stateIdentifier) else {
            return
        }
        switch ticketState {
        case TicketStateId.Moderation,
             TicketStateId.Denied,
             TicketStateId.Accepted,
             TicketStateId.OnReview:
            icon = AppImages.pendingIcon

        case TicketStateId.InWork:
            icon = AppImages.inProgressIcon

        case TicketStateId.Done:
            icon = AppImages.doneIcon

        }

        return
    }

    convenience init(content: [GeoTicket]) {
        self.init(position: CLLocationCoordinate2D.midlePointOfClusterContent(content))
        iconView = UIView.holePieChartWith(content)
    }

}

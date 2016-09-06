//
//  Notification.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping

class Notification: NSObject {

    var message: String?
    var ticketIdentifier: NSNumber?
    var ticketStatus: NSNumber?

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping.addAttributesFromDictionary([
            "message" : "alert",
            "ticketIdentifier" : "ticket_id",
            "ticketStatus" : "status"
            ])

        return mapping
    }

}

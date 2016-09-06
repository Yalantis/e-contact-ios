//
//  TicketCreationResponse.swift
//  e-contact
//
//  Created by Illya on 3/31/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping

class TicketCreationResponse: ResponseProtocol {

    // MARK: - Public properties

    var ticketId: Int?

    // MARK: - Initializer

    required init (JSON: AnyObject) {

        if let JSONDict = JSON as? [NSObject: AnyObject], id = JSONDict["id"] as? Int {
            ticketId = id
        }
    }

}

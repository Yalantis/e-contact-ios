//
//  TicketCreationRequest.swift
//  e-contact
//
//  Created by Illya on 3/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping

struct TicketCreationRequest: AuthorizedAPIRequestProtocol {

    typealias Response = TicketCreationResponse

    // MARK: - Public properties

    var ticket: Ticket
    var path = "ticket"
    var parameters: [String : AnyObject]? {
        let mapping = Ticket.representationMapping()

        if let JSONDict = FEMSerializer.serializeObject(ticket, usingMapping: mapping) as? [String : AnyObject] {
            return JSONDict
        }

        return nil
    }
    var HTTPMethod: Method { return .POST }

    // MARK: - Init

    init(ticket: Ticket) {
        self.ticket = ticket
    }

}

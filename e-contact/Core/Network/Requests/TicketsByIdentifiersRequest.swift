//
//  TicketsByIdentifiersRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/25/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

struct TicketsByIdentifiersRequest: APIRequestProtocol {

    typealias Response = TicketsResponse

    // MARK: - Public properties

    var path: String {
        return "tickets-by-ids?ticket_ids=" + ticketsIdentitfiersString
    }

    // MARK: - Private properties

    private let ticketsIdentifiers: [Int]

    private var ticketsIdentitfiersString: String {
        var result = ""
        result.reserveCapacity(ticketsIdentifiers.capacity)

        for identifier in ticketsIdentifiers {
            result.appendContentsOf(String(identifier))
            result.appendContentsOf(Constants.Networking.Сomma)
        }

        result = String(result.characters.dropLast())
        return result
    }

    // MARK: - Init

    init(ticketsIdentifiers: [Int]) {
        self.ticketsIdentifiers = ticketsIdentifiers
    }

}

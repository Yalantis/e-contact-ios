//
//  TicketRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum TicketStatus: String {

    case Pending = "1,3,4"
    case InProgress = "5"
    case Done = "6"

    static let allStatuses = [TicketStatus.InProgress, TicketStatus.Done, TicketStatus.Pending]

    static func pendingIdentifiers() -> [Int] {
        var statusIdentifiers = [Int]()

        for identifier in TicketStatus.Pending.rawValue.componentsSeparatedByString(Constants.Networking.Сomma) {
            statusIdentifiers.append(Int(identifier)!)
        }
        return statusIdentifiers
    }

}

struct TicketRequest: AuthorizedAPIRequestProtocol {

    typealias Response = TicketResponse

    // MARK: - Public properties

    var path: String {
        if User.currentUser() != nil {
            return "my-ticket/\(identifier.integerValue)"
        } else {
            return "ticket/\(identifier.integerValue)"
        }
    }

    // MARK: - Private properties

    private let identifier: NSNumber!

    // MARK: - Init

    init(ticketIdentifier: NSNumber) {
        identifier = ticketIdentifier
    }

}

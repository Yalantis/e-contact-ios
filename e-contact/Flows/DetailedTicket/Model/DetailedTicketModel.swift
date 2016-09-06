//
//  DetailedTicketModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

final class DetailedTicketModel {

    var isCurrnetUserTicket = false
    private let ticketService: TicketService
    private(set) var from: DetailedTicketFrom!
    private(set) var ticket: Ticket! {
        didSet {
            isCurrnetUserTicket = ticket.user == User.currentUser()
        }
    }
    private(set) var ticketIdentifier: Int?
    private unowned var locator: ServiceLocator

    init(locator: ServiceLocator) {
        self.locator = locator
        self.ticketService = locator.getService()
    }

    func setTicketIdentifier(identifier: Int?, from: DetailedTicketFrom) {
        guard let identifier = identifier else {
            return
        }
        self.from = from
        self.ticketIdentifier = identifier
    }

    func setTicket(ticket: Ticket?, from: DetailedTicketFrom) {
        guard let ticket = ticket else {
            return
        }
        self.from = from
        self.ticket = ticket
    }

    func likeTicket(with ticketIdentifier: Int, facebookTokenString: String, success: () -> Void, failure: ResponseHandler) {
        ticketService.likeTicket(with: ticketIdentifier,
                                 tokenString: facebookTokenString,
                                 success: success,
                                 failure: failure)
    }

    func updateTicket(success: () -> Void, failure: () -> Void) {
        if let ticketIdentifier = ticketIdentifier {
            loadTicket(with: ticketIdentifier, success: success, failure: failure)
        } else if let ticketIdentifier = ticket.identifier?.integerValue {
            loadTicket(with: ticketIdentifier, success: success, failure: failure)
        }
    }

   private func loadTicket(with ticketIdentifier: Int, success: (() -> Void)? = nil, failure: () -> Void) {
        ticketService.loadTicket(with: ticketIdentifier, success: { [weak self] ticket in
            self?.ticket = ticket
            success?()
            }, failure: failure)
    }

    // swiftlint:disable cyclomatic_complexity
    func shouldHideCell(at indexPath: NSIndexPath) -> Bool {
        guard let row = DetailedTicketRow(rawValue: indexPath.row), ticket = ticket else {
            return true
        }

        switch row {
        case .CreatedDate, .Content, .Category:
            return false

        case .PerformerComments where ticket.comment != nil:
            return !isCurrnetUserTicket

        case .PerformerAnswer where (ticket.answers?.allObjects.last as? TicketAnswer)?.originName != nil:
            return !isCurrnetUserTicket

        case .RegisteredDate:
            return ticket.startedDate?.dateString() == nil

        case .DeadLine:
            return ticket.deadline?.dateString() == nil

        case .Completion:
            return ticket.completedDate?.dateString() == nil

        case .Address:
            return ticket.ticketAddress?.localAddressString == nil && ticket.geoAddress?.name == nil

        case .Performer where ticket.performersString != nil:
                return !isCurrnetUserTicket

        case .Images:
            return ticket.imagesPaths?.count == 0

        default:
            return true
        }
    }

}

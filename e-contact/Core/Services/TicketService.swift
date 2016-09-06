//
//  TicketService.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

final class TicketService {

    private unowned let apiClient: RestAPIClient

    init(apiClient: RestAPIClient) {
        self.apiClient = apiClient
    }

    func loadTicket(with ticketIdentifier: Int, success: Ticket -> Void, failure: () -> Void) {
        let request = TicketRequest(ticketIdentifier: ticketIdentifier)

        apiClient.executeRequest(request, success: { ticketResponse in
            if let ticket = ticketResponse.ticket {
                success(ticket)
            }
            }, failure: {error in
                failure()
        })
    }

    func likeTicket(with ticketIdentifier: Int,
                    tokenString: String,
                    success: () -> Void,
                    failure: ResponseHandler) {

        let request = LikeTicketRequest(identifier: ticketIdentifier, fbToken: tokenString)
        apiClient.executeRequest(request, success: { response in
            success()
        }, failure: failure)
    }

    func loadClusterTickets(with ticketsIdentifiers: [Int], success: [Ticket]? -> Void, failure: ResponseHandler) {
        let request = TicketsByIdentifiersRequest(ticketsIdentifiers: ticketsIdentifiers)

        apiClient.executeRequest(request, success: { response in
            success(response.tickets)
            }, failure: failure)
    }

    // swiftlint:disable function_parameter_count
    func loadTickets(state: TicketStatus?,
                     categories: [TicketCategory]?,
                     amount: Int,
                     offset: Int ,
                     success: [Ticket]? -> Void,
                     failure: ResponseHandler) {
        let request = TicketsRequest(state: state,
                                     categories: categories,
                                     amount: amount,
                                     offset: offset)

        apiClient.executeRequest(request, success: { response in
            success(response.tickets)
        }, failure: failure)
    }

    func loadMyTickets(with amount: Int,
                       offset: Int,
                       success: [Ticket]? -> Void,
                       failure: ResponseHandler) {
        let request = MyTicketsRequest(amount: amount, offset: offset)

        apiClient.executeRequest(request, success: { response in
            success(response.tickets)
            }, failure: failure)
    }

}

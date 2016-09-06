//
//  MyTicketsListDataProvider.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/28/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class MyTicketsListDataProvider: TicketsListDataProvider {

    override func loadTickets(amount amount: Int = Constants.TicketsFetching.TicketsAmount,
                              offset: Int = 0,
                              refreshControl: UIRefreshControl?) {

        ticketService.loadMyTickets(with: amount, offset: offset, success: { [weak self] response in
            self?.apiClientCompletionHandler(refreshControl)(response)
            }, failure: { [weak self] response in
                self?.showAlertOnRequestFailureIfNeeded(refreshControl)
                self?.apiClientFailureHandler(refreshControl)(response)
            })
    }

}

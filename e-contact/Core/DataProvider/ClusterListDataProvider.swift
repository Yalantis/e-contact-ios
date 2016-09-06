//
//  ClusterListDataProvider.swift
//  e-contact
//
//  Created by Igor Muzyka on 6/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ClusterListDataProvider: TicketsListDataProvider {

    lazy var batchSize = 10
    private var ticketsIdentifiersToLoad: [Int]
    private var connectionErrorAlertIsShown = false

    init(ticketsIdentifiers: [Int]) {
        ticketsIdentifiersToLoad = ticketsIdentifiers.sort { return $0 > $1 }
    }

    override func showAlertOnRequestFailureIfNeeded(refreshControl: UIRefreshControl?) {
        if !connectionErrorAlertIsShown {
            connectionErrorAlertIsShown = !connectionErrorAlertIsShown
            AlertManager.sharedInstance.showSimpleAlert("network.error.no_internet_connection".localized())
        }
    }

    override func loadTickets(amount amount: Int = Constants.TicketsFetching.TicketsAmount,
                                     offset: Int = 0,
                                     refreshControl: UIRefreshControl?) {
        if ticketsIdentifiersToLoad.isEmpty {
            return
        }

        ticketService.loadClusterTickets(with: sliceBatchForLoading(), success: { [weak self] response in
            self?.apiClientCompletionHandler(refreshControl)(response)
            }, failure: { [weak self] response in
                self?.showAlertOnRequestFailureIfNeeded(refreshControl)
                self?.apiClientFailureHandler(refreshControl)(response)
            })
    }

    private func sliceBatchForLoading() -> [Int] {
        var batch = [Int]()

        batch = Array(ticketsIdentifiersToLoad.prefix(batchSize))
        ticketsIdentifiersToLoad.removeFirst(batch.count)

        return batch
    }

}

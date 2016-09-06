//
//  TicketsListDataProvider.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class TicketsListDataProvider {


    var ticketStatus: TicketStatus?
    var categories: [TicketCategory]? {
        didSet {
            refreshWithRefreshControl(nil)
        }
    }
    var endReached: Bool = false {
        didSet {
            if endReached {
                loadMoreAfterCooldown()
            } else {
                cooldownScheduler?.stop()
                cooldownScheduler = nil
            }
        }
    }
    var ticketService: TicketService!
    private(set) var alreadyRefreshing = false
    private var cooldownScheduler: ScheduledActionsPerformer?
    private var currentPageIndex = 0
    private var alreadyLoading = false


    // MARK: - Public methods

    @objc func refreshWithRefreshControl(refreshControl: UIRefreshControl?) {
        let amount = max(currentPageIndex, 1) * Constants.TicketsFetching.TicketsAmount
        let offset = 0
        loadTickets(amount: amount, offset: offset, refreshControl: refreshControl)
    }

    func refresh() {
        alreadyRefreshing ? () : refreshWithRefreshControl(nil)
        alreadyRefreshing = !alreadyRefreshing
    }

    func loadMore() {
        if !alreadyLoading {
            alreadyLoading = !alreadyLoading
            let amount = Constants.TicketsFetching.TicketsAmount
            let offset = currentPageIndex * amount
            loadTickets(amount: amount, offset: offset, refreshControl: nil)
        }
    }

    func showAlertOnRequestFailureIfNeeded(refreshControl: UIRefreshControl?) {
        if refreshControl != nil {
            AlertManager.sharedInstance.showSimpleAlert("network.error.no_internet_connection".localized())
        }
    }

    func loadTickets(amount amount: Int = Constants.TicketsFetching.TicketsAmount,
                                    offset: Int = 0,
                                    refreshControl: UIRefreshControl?) {

        ticketService.loadTickets(ticketStatus,
                                  categories: categories,
                                  amount: amount,
                                  offset: offset, success: { [weak self] response in
                self?.apiClientCompletionHandler(refreshControl)(response)
            }, failure: { [weak self] response in
                self?.showAlertOnRequestFailureIfNeeded(refreshControl)
                self?.apiClientFailureHandler(refreshControl)(response)
            })
    }

    func apiClientCompletionHandler(refreshControl: UIRefreshControl?) -> ([Ticket]? -> Void) {
        return { [weak self] tickets in
            guard let this = self  else {
                return
            }
            if let _refreshControl = refreshControl {
                _refreshControl.endRefreshing()
                this.endReached = false
            }

            if let tickets = tickets {
                let ticketsAmount = tickets.count

                if ticketsAmount < Constants.TicketsFetching.TicketsAmount {
                    this.endReached = true
                }

                if refreshControl == nil
                    && !this.endReached
                    && ticketsAmount == Constants.TicketsFetching.TicketsAmount {
                    this.currentPageIndex += 1
                }
            }

            this.alreadyLoading = false
            this.alreadyRefreshing = false
        }
    }

    func apiClientFailureHandler(refreshControl: UIRefreshControl?) -> ResponseHandler {
        return { [weak self] error in
            guard let this = self  else {
                return
            }
            if let _refreshControl = refreshControl {
                _refreshControl.endRefreshing()
                this.endReached = false
            }

            this.alreadyLoading = false
            this.alreadyRefreshing = false
        }
    }

    // MARK: - Private methods

    private func loadMoreAfterCooldown() {
        if cooldownScheduler == nil {
            cooldownScheduler = ScheduledActionsPerformer(scheduledAction: { [weak self] in
                self?.endReached = true
                self?.loadMore()
                }, timeInterval: Constants.TicketsFetching.LoadMoreItemsCooldownInterval)
            cooldownScheduler?.start()
        }
    }

}

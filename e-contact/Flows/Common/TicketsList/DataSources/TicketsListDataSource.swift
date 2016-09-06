//
//  TicketsListDataSource.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import MagicalRecord

protocol DataPresenter: class {

    func reloadData()

}

class TicketsListDataSource: NSObject {

    var categories: [TicketCategory]? {
        didSet {
            if categories != nil {
                resetFetchedResultsController()
            }
        }
    }
    weak var cellsDelegate: FeedCellsDelegate?
    weak var dataPresenter: DataPresenter?
    private var fetchedResultsController: NSFetchedResultsController?
    private var statePredicate: NSPredicate
    private var cellIdentifier: String

    // MARK: - init

    init(statePredicate: NSPredicate, cellIdentifier: String) {
        self.statePredicate = statePredicate
        self.cellIdentifier = cellIdentifier
        super.init()
        setupFetchedResultsController()
    }

    // MARK: - Setup

    private func setupFetchedResultsController() {
        var fetchPredicate = statePredicate

        if let categories = categories where !categories.isEmpty {
            var predicates = [NSPredicate]()

            for category in categories {
                let categoryPredicate = NSPredicate(format: "%K == %@", "category.name", category.name!)
                predicates.append(categoryPredicate)
            }

            let categoriesPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            fetchPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchPredicate, categoriesPredicate])
        }

        fetchedResultsController = Ticket.MR_fetchAllSortedBy("createdDate",
                                                              ascending: false,
                                                              withPredicate: fetchPredicate,
                                                              groupBy: nil,
                                                              delegate: self)
    }

    // MARK: - Private

    private func resetFetchedResultsController() {
        setupFetchedResultsController()
        dataPresenter?.reloadData()
    }

    // MARK: - cell configuring

    private func ticketAtIndexPath(indexPath: NSIndexPath) -> Ticket? {
        return fetchedResultsController?.objectAtIndexPath(indexPath) as? Ticket
    }

    private func configure(cell: FeedBaseCell, atIndexPath indexPath: NSIndexPath) {
        let ticket = ticketAtIndexPath(indexPath)
        cell.delegate = cellsDelegate
        cell.ticket = ticket
    }

}

// MARK: - UITableViewDataSource

extension TicketsListDataSource: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? FeedBaseCell)!
        configure(cell, atIndexPath: indexPath)

        return cell
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension TicketsListDataSource: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        dataPresenter?.reloadData()
    }

    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
        guard let dataPresenter = dataPresenter where indexPath != nil else {
            return
        }
        dataPresenter.reloadData()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dataPresenter?.reloadData()
    }

}

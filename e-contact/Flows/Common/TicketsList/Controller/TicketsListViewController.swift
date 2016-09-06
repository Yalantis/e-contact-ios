//
//  TicketsListViewController.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/14/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class TicketsListViewController: UITableViewController, StoryboardInitable, DataPresenter {

    static let storyboardName = "Feed"

    var ticketStatus: TicketStatus?
    var categories: [TicketCategory]? {
        didSet {
            dataProvider?.categories = categories
            dataSource?.categories = categories
        }
    }
    var dataSource: TicketsListDataSource?
    var dataProvider: TicketsListDataProvider?

    private weak var locator: ServiceLocator!
    private var contentOffsets: CGPoint?
    var shouldSaveInsets: Bool = true

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadOffsetsIfNeeded()
        dataProvider?.refresh()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        saveOffsetsIfNeeded()
    }

    // MARK: - DataPresenter protocol

    func reloadData() {
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setup() {
        dataProvider?.ticketService = locator.getService()

        setupDataSource()
        setupRefreshControl()

        dataProvider?.loadMore()
    }

    private func setupDataSource() {
        tableView.delegate = self
        tableView.dataSource = self.dataSource
        dataSource?.dataPresenter = self
    }

    private func setupRefreshControl() {
        if let dataProvider = dataProvider {
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(dataProvider,
                                      action: #selector(TicketsListDataProvider.refreshWithRefreshControl),
                                      forControlEvents: .ValueChanged)
        }
    }

    // MARK: - Offsets

    private func saveOffsetsIfNeeded() {
        if shouldSaveInsets {
            contentOffsets = tableView.contentOffset
        }
    }

    private func loadOffsetsIfNeeded() {
        if let offsets = contentOffsets where shouldSaveInsets {
            tableView.contentOffset = offsets
        }
    }

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    // MARK: - Public

    func resetDataSource(dataSource: TicketsListDataSource) {
        self.dataSource = dataSource
        setupDataSource()
    }

}

// MARK: - UITableViewDelegate

extension TicketsListViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cellsDelegate = dataSource?.cellsDelegate,
            cell = tableView.cellForRowAtIndexPath(indexPath) as? FeedBaseCell {
            cellsDelegate.detailsButtonPressedInCell(cell)
        }
    }

}

// MARK: - UIScrollViewDelegate

extension TicketsListViewController {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let triggeredSize = scrollView.contentSize.height - scrollView.frame.size.width
        if scrollView.contentOffset.y > triggeredSize {
             dataProvider?.loadMore()
        }
    }

}

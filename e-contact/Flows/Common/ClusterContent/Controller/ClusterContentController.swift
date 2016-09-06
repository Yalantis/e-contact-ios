//
//  ClusterContentController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/3/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class ClusterContentController: UIViewController, StoryboardInitable {

    static let storyboardName = "Feed"

    private var ticketIdentifiers: [Int]!

    private(set) var router: ClusterContentRouter!
    private(set) weak var locator: ServiceLocator!

    //MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTicketsListViewController()
        setupBackBarButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        subscribeForAlerts()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
    }

    // MARK: Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: ClusterContentRouter) {
        self.router = router
    }

    func setTicketIdentifiers(ticketIdentifiers: [Int]) {
        self.ticketIdentifiers = ticketIdentifiers
    }

    // MARK: Private methods

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func addTicketsListViewController() {
        let controller = TicketsListViewController.create()
        let predicate = NSPredicate(format: "%@ contains[c] identifier", ticketIdentifiers)
        let dataSource = TicketsListDataSource(statePredicate: predicate,
                                               cellIdentifier: ProfileFeedCell.reuseIdentifier)
        dataSource.cellsDelegate = self
        controller.shouldSaveInsets = false
        controller.setLocator(locator)
        controller.dataProvider = ClusterListDataProvider(ticketsIdentifiers: ticketIdentifiers)
        controller.dataSource = dataSource

        setChildController(controller)
    }

    private func setChildController(controller: TicketsListViewController) {
        controller.view.frame = view.bounds
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }

}

extension ClusterContentController: FeedCellsDelegate {

    func detailsButtonPressedInCell(cell: FeedBaseCell) {
        router.showDetailedTicket(with: cell.ticket!, from: .TicketsList)
    }

}

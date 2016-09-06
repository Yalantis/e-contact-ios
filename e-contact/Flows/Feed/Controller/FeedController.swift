//
//  FeedController.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum FeedPage: Int {

    case InProgress = 0
    case Done
    case Pending

    static let allPages = [FeedPage.InProgress, FeedPage.Done, FeedPage.Pending]

    var statePredicate: NSPredicate {
        let notLocalTicketPredicate = NSPredicate(format: "%K == %@", "localIdentifier", NSNumber(integer: 0))
        var predicates = [NSPredicate]()

        predicates.append(notLocalTicketPredicate)

        if self == .Pending {
            let predicate = NSPredicate(format: "%@ contains[c] state.identifier", TicketStatus.pendingIdentifiers())

            predicates.append(predicate)
        } else {
            let statusIdentifier = (self == .InProgress) ? TicketStatus.InProgress.rawValue : TicketStatus.Done.rawValue

            predicates.append(
                NSPredicate(format: "%K == %@", "state.identifier", NSNumber(integer: Int(statusIdentifier)!))
            )
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    var ticketStatus: TicketStatus {
        return TicketStatus.allStatuses[self.rawValue]
    }

    var cellReuseIdentifier: String {
        return FeedCell.reuseIdentifier
    }

}

final class FeedController: UIViewController, StoryboardInitable {

    static let storyboardName = "Feed"

    private var feedPagesViewControllers: [TicketsListViewController]!
    private var router: FeedRouter!
    private weak var locator: ServiceLocator!
    private var categoryWrapper = TicketCategoryWrapper()

    @IBOutlet private var feedPagesViewContainters: [UIView]?
    @IBOutlet private var segmentedControl: FeedSegmentedControl!
    @IBOutlet private var scrollView: FeedScrollView!
    @IBOutlet private var placeholderView: UIView!
    @IBOutlet private var showMapButton: UIBarButtonItem!

    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        updateView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
    }

    // MARK: - Setup

    private func updateView() {
        router.switchToFeed(tabBarController!)
        applyCategoriesToPages()
        updateFilterItemImage()
        router.showTabBar(true)
        subscribeForAlerts()
        showMapButton.enabled = true
    }

    private func setup() {
        setupChildViewControllers()
        setupSegmentedControlHandler()
        setupSrollViewHandler()
        configureSegmentedControl()
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupSrollViewHandler() {
        scrollView.pageChangeHandler = { [weak self] page in
            self!.segmentedControl.currentPage = page
        }
    }

    private func setupSegmentedControlHandler() {
        segmentedControl.pageChangeHandler = { [weak self] page in
            self!.scrollView.currentPage = page
        }
    }

    private func setupChildViewControllers() {
        feedPagesViewControllers = [
            TicketsListViewController.create(),
            TicketsListViewController.create(),
            TicketsListViewController.create()
        ]

        for feedPage in FeedPage.allPages {
            addFeedChildViewController(childViewController: feedPagesViewControllers[feedPage.rawValue],
                                       containerView: feedPagesViewContainters![feedPage.rawValue],
                                       feedPage: feedPage)
        }
    }

    // MARK: - UI Configuration

    private func configureSegmentedControl() {
        let attributes = NSDictionary(object: UIFont.applicationFontOfSize(14), forKey: NSFontAttributeName)
        segmentedControl.setTitleTextAttributes(attributes as [NSObject : AnyObject], forState: .Normal)
    }

    private func updateFilterItemImage() {
        let image = !categoryWrapper.isEmpty ? AppImages.filterActive : AppImages.filterDisabled
        let filterItem = UIBarButtonItem(image: image,
                                         style: .Plain,
                                         target: self,
                                         action: #selector(FeedController.categoryFiltersButtonTapped))
        navigationItem.rightBarButtonItem = filterItem
    }

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: FeedRouter) {
        self.router = router
    }

    // MARK: - Actions

    @IBAction private func mapButtonTouchUpInside(sender: AnyObject?) {
        showMapButton.enabled = false
        router.hideTabBar(true)
        router.showMap()
    }

    @objc @IBAction private func categoryFiltersButtonTapped(sender: AnyObject?) {
        if UserInteractionLocker.isInterfaceAccessible {
            UserInteractionLocker.lock()
            router.hideTabBar(true)
            router.showCategoryPicker(with: categoryWrapper, state: .Feed)
        }
    }

    // MARK: - Helper methods

    private func addFeedChildViewController(childViewController childViewController: TicketsListViewController,
                                                                containerView: UIView,
                                                                feedPage: FeedPage) {
        let dataSource = TicketsListDataSource(statePredicate: feedPage.statePredicate,
                                               cellIdentifier: feedPage.cellReuseIdentifier)

        let dataProvider = TicketsListDataProvider()
        dataProvider.ticketStatus = feedPage.ticketStatus

        dataSource.cellsDelegate = self
        childViewController.setLocator(locator)
        childViewController.ticketStatus = feedPage.ticketStatus
        childViewController.dataSource = dataSource
        childViewController.dataProvider = dataProvider
        childViewController.view.frame = containerView.bounds

        addChildViewController(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.didMoveToParentViewController(self)
    }

    private func applyCategoriesToPages() {
        for pageViewController in feedPagesViewControllers {
            pageViewController.categories = categoryWrapper.categories
        }
    }

}

extension FeedController: FeedCellsDelegate {

    func detailsButtonPressedInCell(cell: FeedBaseCell) {
        if UserInteractionLocker.isInterfaceAccessible {
            UserInteractionLocker.lock()
            router.hideTabBar(true)
            router.showDetailedTicket(with: cell.ticket!, from: .TicketsList)
        }
    }

}

extension FeedController: LoginDisplayable {

    func displayLogin() {
        router.hideTabBar(true)
        router.showLogin()
    }

}

extension FeedController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}

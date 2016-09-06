//
//  ProfileController.swift
//  e-contact
//
//  Created by Boris on 3/24/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Foundation

enum ProfileFeedPage: Int {

    case MyTickets = 0
    case Draft

    var cellReuseIdentifier: String {
        return (self == .MyTickets) ? ProfileFeedCell.reuseIdentifier : DraftFeedCell.reuseIdentifier
    }

}

final class ProfileController: UIViewController, StoryboardInitable {

    static let storyboardName = "Profile"

    private var router: ProfileRouter!
    private weak var locator: ServiceLocator!
    private var myTicketsViewController: TicketsListViewController!
    private var draftTicketsViewController: TicketsListViewController!

    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var myTicketsViewContainer: UIView!
    @IBOutlet private var draftTicketsViewContainer: UIView!
    @IBOutlet private var segmentedControl: ProfileFeedSegmentedControl!
    @IBOutlet private var scrollView: ProfileFeedScrollView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        resetMyTicketsListDataSourceIfPossible()

        router.showTabBar(true)
        subscribeForAlerts()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let user = User.currentUser() {
            fillUserData(user)
            navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        router.switchToProfile(tabBarController!)
    }

    // MARK: - Setup

    private func setup() {
        setupChildViewControllers()
        setupSegmentedControlHandler()
        setupSrollViewHandler()
        configureSegmentedControl()
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupChildViewControllers() {
        setupMyTicketsViewController()
        setupDraftTicketsViewController()
    }

    private func setupMyTicketsViewController() {
        guard let userId = CredentialStorage.defaultCredentialStorage().userSession?.id else {
            return
        }
        myTicketsViewController = TicketsListViewController.create()
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "user.identifier",
                                    userId, "localIdentifier",
                                    NSNumber(integer: 0))
        let dataSource = TicketsListDataSource(statePredicate: predicate,
                                               cellIdentifier: ProfileFeedPage.MyTickets.cellReuseIdentifier)

        addProfileChildViewController(childViewController: myTicketsViewController,
                                      dataSource: dataSource,
                                      dataProvider: MyTicketsListDataProvider(),
                                      containerView: myTicketsViewContainer)
    }

    private func setupDraftTicketsViewController() {
        draftTicketsViewController = TicketsListViewController.create()
        let predicate = NSPredicate(format: "%K != %@", "localIdentifier", NSNumber(integer: 0))
        let dataSource = TicketsListDataSource(statePredicate: predicate,
                                               cellIdentifier: ProfileFeedPage.Draft.cellReuseIdentifier)

        addProfileChildViewController(childViewController: draftTicketsViewController,
                                      dataSource: dataSource,
                                      dataProvider: nil,
                                      containerView: draftTicketsViewContainer)
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

    // MARK: - Helper method

    private func addProfileChildViewController(childViewController childViewController: TicketsListViewController,
                                                                   dataSource: TicketsListDataSource,
                                                                   dataProvider: TicketsListDataProvider?,
                                                                   containerView: UIView) {
        dataSource.cellsDelegate = self
        childViewController.setLocator(locator)
        childViewController.dataSource = dataSource
        childViewController.dataProvider = dataProvider
        childViewController.view.frame = containerView.bounds

        addChildViewController(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.didMoveToParentViewController(self)
    }

    // MARK: - Private Methods

    private func resetMyTicketsListDataSourceIfPossible() {
        guard let userId = CredentialStorage.defaultCredentialStorage().userSession?.id else {
            return
        }
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "user.identifier",
                                    userId, "localIdentifier",
                                    NSNumber(integer: 0))
        let dataSource = TicketsListDataSource(statePredicate: predicate,
                                               cellIdentifier: ProfileFeedPage.MyTickets.cellReuseIdentifier)
        dataSource.cellsDelegate = self
        myTicketsViewController.resetDataSource(dataSource)
    }

    private func configureSegmentedControl() {
        let attributes = NSDictionary(object: UIFont.applicationFontOfSize(14), forKey: NSFontAttributeName)
        segmentedControl.setTitleTextAttributes(attributes as [NSObject : AnyObject], forState: .Normal)
    }

    private func fillUserData(userData: User) {
        fullNameLabel.text = getFullNameString(userData)

        if let addressString = userData.address?.localAddressString {
            addressLabel.text = addressString
        }

        emailLabel.text = userData.email!
    }

    private func getFullNameString(user: User) -> String {
        var fullNameString = ""

        if let firstName = user.firstName {
            fullNameString += firstName
        }
        if let middleName = user.middleName {
            fullNameString += " " + middleName
        }
        if let lastName = user.lastName {
            fullNameString += " " + lastName
        }

        return fullNameString
    }

    // MARK: - Actions

    @IBAction func toEditProfile(sender: AnyObject) {
        router.hideTabBar(true)
        router.showEditProfile()
    }

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: ProfileRouter) {
        self.router = router
    }

}

extension ProfileController: FeedCellsDelegate {

    func detailsButtonPressedInCell(cell: FeedBaseCell) {
        router.hideTabBar(true)
        if cell.isMemberOfClass(DraftFeedCell) {
            router.showTicketCreation(cell.ticket!)
        } else if cell.isMemberOfClass(ProfileFeedCell) {
            router.showDetailedTicket(with: cell.ticket!, from: .TicketsList)
        }
    }

}

extension ProfileController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}

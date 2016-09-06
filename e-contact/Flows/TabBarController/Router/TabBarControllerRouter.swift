//
//  TabBarControllerRouter.swift
//  e-contact
//
//  Created by Igor Muzyka on 3/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class TabBarControllerRouter: AlertManagerDelegate, FeedPresenter, ProfilePresenter, TicketCreationPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension TabBarControllerRouter: Router {

    func execute(context: UIWindow) -> AnyObject? {
        let tabBarController = TabBarController.create()

        tabBarController.setRouter(self)
        tabBarController.setLocator(locator)
        setupViewControllers(tabBarController)

        self.currentViewController = tabBarController
        context.rootViewController = tabBarController
        return nil
    }

    private func setupViewControllers(tabBarController: TabBarController) {
        let feedController = loadFeed()
        let profileController = loadProfile()
        let viewControllers = [feedController, profileController]
        tabBarController.setViewControllers(viewControllers, animated: false)
    }

}

protocol TabBarPresenter: NavigationProtocol {

    func showTabBar(animated: Bool)
    func hideTabBar(animated: Bool)

}

extension TabBarPresenter {

    func showTabBar(animated: Bool) {
        // swiftlint:disable:next force_cast
        (currentViewController.tabBarController as! TabBarController).tabBarView.show(animated)
    }

    func hideTabBar(animated: Bool) {
        // swiftlint:disable:next force_cast
        (currentViewController.tabBarController as! TabBarController).tabBarView.hide(animated)
    }

}

//
//  FeedRouter.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class FeedRouter: AlertManagerDelegate,
    TabBarPresenter,
    MapPresenter,
    DetailedTicketPresenter,
    CategoryPickerPresenter,
    LoginPresenter,
    FeedPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension FeedRouter:  Router {

    func execute(context: AnyObject?) -> AnyObject? {
        let controller = FeedController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        self.currentViewController = controller
        return AppearanceNavigationController(rootViewController: controller)
    }

}

protocol FeedPresenter: NavigationProtocol {

    func loadFeed() -> UINavigationController

    func switchToFeed(tabBarController: UITabBarController)

}

extension FeedPresenter {

    func loadFeed() -> UINavigationController {
        let feedRouter = FeedRouter(locator: locator)
        // swiftlint:disable:next force_cast
        return feedRouter.execute(nil) as! UINavigationController
    }

    func switchToFeed(tabBarController: UITabBarController) {
        tabBarController.selectedIndex = TabBarControllerManaged.FeedViewController.rawValue
        if let tabBarControllerDelegate = tabBarController as? UITabBarControllerDelegate {
            tabBarControllerDelegate.tabBarController!(
                tabBarController,
                didSelectViewController: tabBarController.selectedViewController!
            )
        }
    }

}

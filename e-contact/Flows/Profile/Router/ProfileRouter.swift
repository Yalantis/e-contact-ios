//
//  ProfileRouter.swift
//  e-contact
//
//  Created by Boris on 3/24/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ProfileRouter: AlertManagerDelegate,
    TabBarPresenter,
    EditProfilePresenter,
    DetailedTicketPresenter,
    TicketCreationPresenter,
    LoginPresenter,
    ProfilePresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension ProfileRouter:  Router {

    func execute(context: AnyObject?) -> AnyObject? {
        let controller = ProfileController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        self.currentViewController = controller
        return AppearanceNavigationController(rootViewController: controller)
    }

}

protocol ProfilePresenter: NavigationProtocol {

    func loadProfile() -> UINavigationController

    func switchToProfile(tabBarController: UITabBarController)

}

extension ProfilePresenter {

    func loadProfile() -> UINavigationController {
        let profileRouter = ProfileRouter(locator: locator)
        // swiftlint:disable:next force_cast
        return profileRouter.execute(nil) as! UINavigationController
    }

    func switchToProfile(tabBarController: UITabBarController) {
        tabBarController.selectedIndex = TabBarControllerManaged.ProfileViewController.rawValue
        if let tabBarControllerDelegate = tabBarController as? UITabBarControllerDelegate {
            tabBarControllerDelegate.tabBarController!(
                tabBarController,
                didSelectViewController: tabBarController.selectedViewController!
            )
        }
    }

}

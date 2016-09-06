//
//  LaunchRouter.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

protocol Router: class {

    associatedtype Context

    func execute(context: Context) -> AnyObject?

}

class LaunchRouter: AlertManagerDelegate, DetailedTicketPresenter {

    private(set) var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init() {
        locator = ServiceLocator()
        locator.registerService(RestAPIClient())
        locator.registerService(CredentialStorage.defaultCredentialStorage())
        locator.registerService(ImageCachingService())
        locator.registerService(PushNotificationService())
        locator.registerService(CategoryIconsService(apiClient: locator.getService()))
        locator.registerService(UserService(apiClient: locator.getService()))
        locator.registerService(TicketService(apiClient: locator.getService()))
    }

}

extension LaunchRouter: Router {

    func execute(context: UIWindow) -> AnyObject? {
        let launchController = LaunchController.create()
        currentViewController = launchController
        let navigationController = AppearanceNavigationController(rootViewController: launchController)
        context.rootViewController = navigationController
        presentTabBarController(context)
        return nil
    }

    private func presentTabBarController(context: UIWindow) {
        let tabBarControllerRouter = TabBarControllerRouter(locator: locator)
        tabBarControllerRouter.execute(context)
    }

}

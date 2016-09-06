//
//  ChangePasswordRouter.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/23/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ChangePasswordRouter: AlertManagerDelegate {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension ChangePasswordRouter:  Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = ChangePasswordController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        self.currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol ChangePasswordPresenter: NavigationProtocol {

    func showChangePasswordController()

}

extension ChangePasswordPresenter {

    func showChangePasswordController() {
        let router = ChangePasswordRouter(locator: locator)

        router.execute(currentViewController.navigationController!)
    }

}

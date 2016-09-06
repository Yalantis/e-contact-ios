//
//  PasswordRecoveryRouter.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class PasswordRecoveryRouter: AlertManagerDelegate, LoginPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension PasswordRecoveryRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = PasswordRecoveryController.create()
        controller.setRouter(self)
        controller.setModel(PasswordRecoveryModel(locator: locator))
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol PasswordRecoveryPresenter: NavigationProtocol {

    func showPasswordRecovery()

}

extension PasswordRecoveryPresenter {

    func showPasswordRecovery() {
        let passwordRecoveryRouter = PasswordRecoveryRouter(locator: locator)

        passwordRecoveryRouter.execute(currentViewController.navigationController!)
    }

}

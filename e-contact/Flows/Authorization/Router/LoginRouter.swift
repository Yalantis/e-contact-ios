//
//  LoginRouter.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class LoginRouter: AlertManagerDelegate, PasswordRecoveryPresenter, FeedPresenter, ProfilePresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!
    private var returnPoint: ReturnPoint?

    init(locator: ServiceLocator, returnPoint: ReturnPoint? = nil) {
        self.locator = locator
        self.returnPoint = returnPoint
    }

}

extension LoginRouter:  Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = LoginController.create()
        controller.setRouter(self)
        controller.setModel(LoginModel(locator: locator))
        currentViewController = controller
        context.showViewController(controller, sender: self)

        return nil
    }

}

extension LoginRouter: RegistrationPresenter {

    func showRegistration() {
        let registrationRouter = RegistrationRouter(locator: locator, returnPoint: returnPoint)

        if let navigationController = currentViewController.navigationController as? AppearanceNavigationController {
            registrationRouter.execute(navigationController)
        }
    }

}

protocol LoginPresenter: NavigationProtocol {

    func showLogin()

}

extension LoginPresenter {

    func showLogin() {
        let loginRouter = LoginRouter(locator: locator)

        loginRouter.execute(currentViewController.navigationController!)
    }

}

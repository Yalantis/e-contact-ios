//
//  RegistrationRouter.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DigitsKit

class RegistrationRouter: AlertManagerDelegate, TwitterDigitsPresenter, AddressPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!
    private var returnPoint: ReturnPoint?

    init(locator: ServiceLocator, returnPoint: ReturnPoint? = nil) {
        self.locator = locator
        self.returnPoint = returnPoint
    }

    func pop() {
        if let returnPoint = returnPoint {
            returnPoint.popToReturnPoint()
        } else {
            currentViewController.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

}

extension RegistrationRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = RegistrationController.create()
        controller.setRouter(self)
        controller.setModel(RegistrationModel(locator: locator))
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol RegistrationPresenter: NavigationProtocol {

    func showRegistration()

}

extension RegistrationPresenter {

    func showRegistration() {
        let registrationRouter = RegistrationRouter(locator: locator)

        registrationRouter.execute(currentViewController.navigationController!)
    }

}

protocol TwitterDigitsPresenter: NavigationProtocol {

    func showTwitterDigitsValidation(completion: DGTAuthenticationCompletion)

}

extension TwitterDigitsPresenter {

    func showTwitterDigitsValidation(completion: DGTAuthenticationCompletion) {
        let digits = Digits.sharedInstance()
        /** We need to log out firstly to change user phone number (otherwise the app will perform silent authorization
         and use the old phone number) */
        digits.logOut()

        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.appearance = DGTAppearance.defaultAppearance()

        digits.authenticateWithViewController(currentViewController,
                                              configuration: configuration,
                                              completion: completion)
    }

}

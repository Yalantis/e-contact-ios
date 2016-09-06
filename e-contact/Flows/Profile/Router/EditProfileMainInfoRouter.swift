//
//  EditProfileMainInfoRouter.swift
//  e-contact
//
//  Created by Igor Muzyka on 6/2/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class EditProfileMainInfoRouter: AlertManagerDelegate, TabBarPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension EditProfileMainInfoRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = EditProfileMainInfoController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        self.currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol EditProfileMainInfoPresenter: NavigationProtocol {

    func showEditProfileMainInfo()

}

extension EditProfileMainInfoPresenter {

    func showEditProfileMainInfo() {
        let editProfileMainInfoRouter = EditProfileMainInfoRouter(locator: locator)
        editProfileMainInfoRouter.execute(currentViewController.navigationController!)
    }

}

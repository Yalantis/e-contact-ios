//
//  EditProfileRouter.swift
//  e-contact
//
//  Created by Boris on 3/28/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class EditProfileRouter: AlertManagerDelegate,
    TabBarPresenter,
    AddressPresenter,
    FeedPresenter,
    EditProfileMainInfoPresenter,
    ChangePasswordPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator) {
        self.locator = locator
    }

}

extension EditProfileRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = EditProfileController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        self.currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol EditProfilePresenter: NavigationProtocol {

    func showEditProfile()

}

extension EditProfilePresenter {

    func showEditProfile() {
        let profileRouter = EditProfileRouter(locator: locator)

        profileRouter.execute(currentViewController.navigationController!)
    }

}

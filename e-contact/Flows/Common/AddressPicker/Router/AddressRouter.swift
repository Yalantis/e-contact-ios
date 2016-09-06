//
//  AddressRouter.swift
//  e-contact
//
//  Created by Illya on 3/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class AddressRouter: AlertManagerDelegate, RegistrationPresenter, AddressPickerPresenter {

    private(set) var address: LocalAddress?
    private(set) var state: AddressControllerState
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, address: LocalAddress?, state: AddressControllerState) {
        self.locator = locator
        self.state = state
        self.address = address
    }

}

extension AddressRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = AddressController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        controller.setState(state)
        controller.setAddress(address)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol AddressPresenter: NavigationProtocol {

    func showAddressController(with address: LocalAddress?, state: AddressControllerState)

}

extension AddressPresenter {

    func showAddressController(with address: LocalAddress?, state: AddressControllerState) {
        let addressRouter = AddressRouter(locator: locator, address: address, state: state)

        addressRouter.execute(currentViewController.navigationController!)
    }

}

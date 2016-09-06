//
//  AddressPickerRouter.swift
//  e-contact
//
//  Created by Illya on 3/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class AddressPickerRouter: AlertManagerDelegate {

    private(set) var address: LocalAddress
    private(set) var type: AddressRequestType!
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, type: AddressRequestType, address: LocalAddress) {
        self.locator = locator
        self.type = type
        self.address = address
    }

}

extension AddressPickerRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = AddressPickerController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        controller.setType(type, address: address)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol AddressPickerPresenter: NavigationProtocol {

    func showAddressPickerWithRequest(type: AddressRequestType, address: LocalAddress)

}

extension AddressPickerPresenter {

    func showAddressPickerWithRequest(type: AddressRequestType, address: LocalAddress) {
        let addressRouter = AddressPickerRouter(locator: locator, type: type, address: address)

        addressRouter.execute(currentViewController.navigationController!)
    }

}

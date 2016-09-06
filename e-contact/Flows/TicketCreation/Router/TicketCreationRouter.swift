//
//  TicketCreationRouter.swift
//  e-contact
//
//  Created by Illya on 3/25/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import ImagePicker
import RSKImageCropper

class TicketCreationRouter: AlertManagerDelegate,
    TabBarPresenter,
    AddressPresenter,
    CategoryPickerPresenter,
    ImagePickerPresenter,
    RSKImageCropPresenter {

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!
    private weak var ticket: Ticket?

    init(locator: ServiceLocator, ticket: Ticket? = nil) {
        self.locator = locator
        self.ticket = ticket
    }

    func backToRootViewController() {
        currentViewController.navigationController!.popToRootViewControllerAnimated(true)
    }

    func loadImagesController(delegate: TicketCreationImagesDelegate,
                              ticket: Ticket,
                              changes: Changes) -> TicketCreationImagesController {
        let controller = TicketCreationImagesController.create()
        controller.setDelegate(delegate)
        controller.setModel(TicketCreationImagesModel(locator: locator, ticket: ticket))
        controller.changes = changes
        controller.presentImagePicker = { [weak self] controller, delegate in
            self?.showImagePicker(controller, withDelegate: delegate)
        }
        controller.presentImgeCropper = { [weak self] delegate, image, cropMode in
            self?.showRSKImageCrop(delegate, image: image, cropMode: cropMode)
        }

        return controller
    }

    func loadTableViewController(delegate: ResizabelControllerDelegate,
                                 ticket: Ticket,
                                 isFromDraft: Bool,
                                 changes: Changes) -> TicketCreationTableViewController {
        let controller = TicketCreationTableViewController.create()
        controller.setModel(TicketCreationTableModel(ticket: ticket, isFromDraft: isFromDraft), delegate: delegate)
        controller.changes = changes
        controller.presentCategoryPicker = { [weak self] categoriesWrapper, state in
            self?.showCategoryPicker(with: categoriesWrapper, state: state)
        }
        controller.presentAddressPicker = { [weak self] address, state in
            self?.showAddressController(with: address, state: state)
        }

        return controller
    }

}

extension TicketCreationRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = TicketCreationController.create()
        controller.setModel(TicketCreationModel(ticket: ticket, locator: locator))
        controller.setRouter(self)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol TicketCreationPresenter: NavigationProtocol {

    func showTicketCreation(withTicket: Ticket?, tabBarController: UITabBarController?)

}

extension TicketCreationPresenter {

    func showTicketCreation(withTicket: Ticket? = nil, tabBarController: UITabBarController? = nil) {
        let ticketCreationRouter = TicketCreationRouter(locator: locator, ticket:withTicket)
        guard let tabBarController = tabBarController else {

            ticketCreationRouter.execute(currentViewController.navigationController!)
            return
        }
        // swiftlint:disable:next force_cast
        let navigationController = tabBarController.selectedViewController as! UINavigationController

        ticketCreationRouter.execute(navigationController)
    }

}

protocol ImagePickerPresenter: NavigationProtocol {

    func showImagePicker(controller: ImagePickerController, withDelegate delegate: ImagePickerDelegate)

}

extension ImagePickerPresenter {

    func showImagePicker(controller: ImagePickerController, withDelegate delegate: ImagePickerDelegate) {
        controller.delegate = delegate
        currentViewController.presentViewController(controller, animated: false, completion: nil)
    }

}

protocol RSKImageCropPresenter: NavigationProtocol {

    func showRSKImageCrop(delegate: RSKImageCropViewControllerDelegate,
                          image: UIImage,
                          cropMode: RSKImageCropMode)

}

extension RSKImageCropPresenter {

    func showRSKImageCrop(delegate: RSKImageCropViewControllerDelegate,
                          image: UIImage,
                          cropMode: RSKImageCropMode) {
        let controller = RSKImageCropViewController(image: image, cropMode: .Square)
        controller.delegate = delegate
        currentViewController.navigationController?.pushViewController(controller, animated: false)
    }

}

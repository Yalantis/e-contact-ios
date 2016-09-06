//
//  ImagesGalleryRouter.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit


class ImagesGalleryRouter: AlertManagerDelegate {

    private(set) var ticket: Ticket?
    private(set) var imagesPaths: [String]?
    private(set) var focusedIndexPath: NSIndexPath?
    private(set) var ticketTitle: String?
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, imagesPaths: [String], focusedIndexPath: NSIndexPath, ticketTitle: String? = nil) {
        self.locator = locator
        self.imagesPaths = imagesPaths
        self.focusedIndexPath = focusedIndexPath
        self.ticketTitle = ticketTitle
    }

}

extension ImagesGalleryRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = ImagesGalleryController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        controller.setImagesPaths(imagesPaths!, focusedIndexPath: focusedIndexPath!, ticketTitle: ticketTitle)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol ImagesGalleryPresenter: NavigationProtocol {

    func showImagesGalleryWithImagesPaths(imagesPaths: [String], focusedIndexPath: NSIndexPath, ticketTitle: String?)

}

extension ImagesGalleryPresenter {

    func showImagesGalleryWithImagesPaths(imagesPaths: [String],
                                          focusedIndexPath: NSIndexPath,
                                          ticketTitle: String? = nil) {
        let imagesGaleryRouter = ImagesGalleryRouter(locator: locator,
                                                       imagesPaths: imagesPaths,
                                                       focusedIndexPath: focusedIndexPath,
                                                       ticketTitle: ticketTitle)

        imagesGaleryRouter.execute(currentViewController.navigationController!)
    }

}

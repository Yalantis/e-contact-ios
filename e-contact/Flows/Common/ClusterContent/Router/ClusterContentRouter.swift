//
//  ClusterContentRouter.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ClusterContentRouter: AlertManagerDelegate, DetailedTicketPresenter {

    private(set) var ticketIdentifiers: [Int]
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, ticketIdentifiers: [Int] ) {
        self.locator = locator
        self.ticketIdentifiers = ticketIdentifiers
    }

}

extension ClusterContentRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = ClusterContentController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        controller.setTicketIdentifiers(ticketIdentifiers)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol ClusterContentPresenter: NavigationProtocol {

    func showClusterContentWithTicketIdentifiers(ticketIdentifiers: [Int])

}

extension ClusterContentPresenter {

    func showClusterContentWithTicketIdentifiers(ticketIdentifiers: [Int]) {
        let router = ClusterContentRouter(locator: locator, ticketIdentifiers: ticketIdentifiers)

        router.execute(currentViewController.navigationController!)
    }

}

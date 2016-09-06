//
//  MapRouter.swift
//  e-contact
//
//  Created by Illya on 1/8/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class MapRouter: AlertManagerDelegate, DetailedTicketPresenter, ClusterContentPresenter, CategoryPickerPresenter {

    private(set) var ticket: Ticket?
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, ticket: Ticket?) {
        self.locator = locator
        self.ticket = ticket
    }

}

extension MapRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = MapViewController.create()
        controller.model = MapModel(serviceLocator: locator, ticket: ticket)
        controller.setRouter(self)
        currentViewController = controller
        context.showViewController(controller, sender: self)

        return nil
    }

}

protocol MapPresenter: NavigationProtocol {

    func showMap(ticket: Ticket?)

}

extension MapPresenter {

    func showMap(ticket: Ticket? = nil) {
        let mapRouter = MapRouter(locator: locator, ticket: ticket)

        mapRouter.execute(currentViewController.navigationController!)
    }

}

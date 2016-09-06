//
//  DetailedTicketRouter.swift
//  e-contact
//
//  Created by Boris on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class DetailedTicketRouter: AlertManagerDelegate,
    MapPresenter,
    ImagesGalleryPresenter,
    TicketAnswersPresenter,
    ReturnPoint, TabBarPresenter {

    private(set) var ticketIdentifier: Int?
    private(set) var ticket: Ticket?
    private var from: DetailedTicketFrom!

    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator,
         ticketIdentifier: Int? = nil,
         ticket: Ticket? = nil,
         from: DetailedTicketFrom) {
        self.locator = locator
        self.ticketIdentifier = ticketIdentifier
        self.ticket = ticket
        self.from = from
    }

}

extension DetailedTicketRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = DetailedTicketController.create()
        let model = DetailedTicketModel(locator: locator)

        if let ticketIdentifier = ticketIdentifier {
            model.setTicketIdentifier(ticketIdentifier, from: from)
        } else if let ticket = ticket {
            model.setTicket(ticket, from: from)
        }

        controller.setRouter(self)
        controller.setModel(model)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

extension DetailedTicketRouter: LoginPresenter {

    func showLogin() {
        let loginRouter = LoginRouter(locator: locator, returnPoint: self)

        if let navigationController = currentViewController.navigationController as? AppearanceNavigationController {
            loginRouter.execute(navigationController)
        }
    }

}

protocol DetailedTicketPresenter: NavigationProtocol {

    func showDetailedTicket(with ticket: Ticket?, orWith ticketIdentifier: Int?, from: DetailedTicketFrom)

}

extension DetailedTicketPresenter {

    func showDetailedTicket(with ticket: Ticket? = nil, orWith ticketIdentifier: Int? = nil, from: DetailedTicketFrom) {
        let detailedTicketRouter = DetailedTicketRouter(locator: locator,
                                                        ticketIdentifier: ticketIdentifier,
                                                        ticket: ticket,
                                                        from: from)
        detailedTicketRouter.execute(currentViewController.navigationController!)
    }

}

protocol ReturnPoint: NavigationProtocol {

    func popToReturnPoint()

}

extension ReturnPoint {

    func popToReturnPoint() {
        currentViewController.navigationController?.popToViewController(currentViewController, animated: true)
    }

}

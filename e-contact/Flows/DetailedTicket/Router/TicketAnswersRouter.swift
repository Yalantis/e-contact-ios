//
//  TicketAnswersRouter.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit


class TicketAnswersRouter: AlertManagerDelegate, WebViewControllerPresenter {

    private(set) var ticket: Ticket!
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, ticket: Ticket) {
        self.locator = locator
        self.ticket = ticket
    }

}

extension TicketAnswersRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = TicketAnswersController.create()
        controller.setRouter(self)
        controller.setLocator(locator)
        controller.setTicket(ticket)
        currentViewController = controller
        context.showViewController(controller, sender: self)

        return nil
    }

}

protocol TicketAnswersPresenter: NavigationProtocol {

    func showTicketAnswers(ticket: Ticket)

}

extension TicketAnswersPresenter {

    func showTicketAnswers(ticket: Ticket) {
        let router = TicketAnswersRouter(locator: locator, ticket: ticket)

        router.execute(currentViewController.navigationController!)
    }

}

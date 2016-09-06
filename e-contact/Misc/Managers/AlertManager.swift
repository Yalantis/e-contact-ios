//
//  AlertManager.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//


import UIKit
import Toast

private let notification = "Notification"

enum AlertPosition {

    case Top, Center, Bottom

}

protocol AlertManagerDelegate: DetailedTicketPresenter {

    func showActivity()
    func hideActivity()
    func showSimpleAlert(with message: String, handler: ((UIAlertAction) -> Void)?)
    func showNotificationAlertWithTicket(ticket: Ticket)

}

extension AlertManagerDelegate {

    func controllerIsWaitingForResponse() -> Bool {
        return currentViewController.presentedViewController != nil
    }

    func showSimpleAlert(with message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(simpleAlerControllerWith: message, handler: handler)
        currentViewController.presentViewController(alert, animated: true, completion: nil)
    }

    func showActivity() {
        currentViewController.view.makeToastActivity(CSToastPositionCenter)
    }

    func hideActivity() {
        currentViewController.view.hideToastActivity()
    }

    func showNotificationAlertWithTicket(ticket: Ticket) {
        let alert = UIAlertController(notificationAlertControllerWith: { [weak self] actionType in
            switch actionType {
            case .Show:
                self?.showDetailedTicket(with: ticket, from: .PushNotification)

            default:
                break
            }
            })

        currentViewController.presentViewController(alert, animated: true, completion: nil)
    }

}

protocol AlertManagerSubscriptionProtocol: class {

    func alertManagerDidAddNewSubscriber(alertManager: AlertManager)

}

final class AlertManager {

    static let sharedInstance = AlertManager()

    private weak var delegate: AlertManagerDelegate?
    private weak var subscriptionListener: AlertManagerSubscriptionProtocol?

    private init() { }

    var listener: AlertManagerDelegate? {
        set {
            delegate = newValue
            if delegate != nil {
                subscriptionListener?.alertManagerDidAddNewSubscriber(self)
            }
        }
        get {
            return delegate
        }
    }

    func showSimpleAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        if controllerIsWaitingForResponse {
            return
        }
        delegate?.showSimpleAlert(with: message, handler: handler)
    }

    func showActivity() {
        delegate?.showActivity()
    }

    func hideActivity() {
        delegate?.hideActivity()
    }

    var controllerIsWaitingForResponse: Bool {
        guard let result = delegate?.controllerIsWaitingForResponse() else {
            return true
        }

        return result
    }

    func showPushNotificationAlert(with ticket: Ticket) {
        if !controllerIsWaitingForResponse {
            delegate?.showNotificationAlertWithTicket(ticket)
        }
    }

    func setSubscriptionListener(subscriptionListener: AlertManagerSubscriptionProtocol) {
        self.subscriptionListener = subscriptionListener
    }

    func showAlertAfter(delay seconds: Double, with message: String) {
        executeAfter(delay: seconds) { [unowned self] in
            self.showSimpleAlert(message)
        }
    }

}

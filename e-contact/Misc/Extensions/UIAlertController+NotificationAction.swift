//
//  UIAlertController+NotificationAction.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/11/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum NotificationAction: String {

    case Cancel = "ticketCreation.alerts.cancel"
    case Show = "notification.alert.show_ticket"

    func localized() -> String {
        return self.rawValue.localized()
    }

}

extension UIAlertController {

    convenience init(notificationAlertControllerWith handler: (NotificationAction) -> ()) {
        self.init(title: Constants.Notification.Title, message: Constants.Notification.Message, preferredStyle: .Alert)

        addAction(UIAlertAction(style: .Default, actionType: .Show, handler: handler))
        addAction(UIAlertAction(style: .Cancel, actionType: .Cancel, handler: handler))
    }

}

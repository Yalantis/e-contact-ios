//
//  UIAlertAction+ActionsHandler.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIAlertAction {

    convenience init(style: UIAlertActionStyle,
                     actionType: TicketCreationAction,
                     handler: (TicketCreationAction) -> ()) {
        let title = actionType.localized()

        self.init(title: title, style: style) { result in
            handler(actionType)
        }
    }

    convenience init(style: UIAlertActionStyle, actionType: NotificationAction, handler: (NotificationAction) -> ()) {
        let title = actionType.localized()

        self.init(title: title, style: style) { result in
            handler(actionType)
        }
    }

}

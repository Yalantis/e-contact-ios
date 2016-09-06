//
//  UIAlertController + TicketCreationHandler.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit


enum TicketCreationAction: String {

    case Cancel = "ticketCreation.alerts.cancel"
    case DeletePhoto = "ticketCreation.alerts.delete_photo"
    case SaveToDraft = "ticketCreation.alerts.yes"
    case DoNotSaveTicket = "ticketCreation.alerts.no"
    case StopUploading = "ticketCreation.alerts.stop_uploading"

}

extension UIAlertController {

    convenience init(actionAlertContrtoler handler: (TicketCreationAction) -> ()) {
        self.init(title: Constants.TicketCreation.DeletionTittle,
                  message: Constants.TicketCreation.DeletionMessage,
                  preferredStyle: .Alert)

        addAction(UIAlertAction(style: .Default, actionType: .Cancel, handler: handler))
        addAction(UIAlertAction(style: .Destructive, actionType: .DeletePhoto, handler: handler))
    }

    convenience init(backButtonAlertController handler: (TicketCreationAction) -> ()) {
        self.init(title: Constants.TicketCreation.SaveToDraftMessage, message: nil, preferredStyle: .ActionSheet)

        addAction(UIAlertAction(style: .Default, actionType: .SaveToDraft, handler: handler))
        addAction(UIAlertAction(style: .Destructive, actionType: .DoNotSaveTicket, handler: handler))
        addAction(UIAlertAction(style: .Cancel, actionType: .Cancel, handler: handler))
    }

    convenience init(imageUploadingAllertController handler: (TicketCreationAction) -> ()) {
        self.init(title: Constants.TicketCreation.UploadingPhotoMessage, message: nil, preferredStyle: .Alert)

        addAction(UIAlertAction(style: .Cancel, actionType: .StopUploading, handler: handler))
    }

}

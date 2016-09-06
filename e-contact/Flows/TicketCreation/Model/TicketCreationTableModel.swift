//
//  TicketCreationTableModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class TicketCreationTableModel {

    var ticket: Ticket!
    var isShowLocationCellsState = false
    private var isFromDraft = false

    init(ticket: Ticket, isFromDraft: Bool = false) {
        self.ticket = ticket
        self.isFromDraft = isFromDraft
    }

    func shouldHideCell(at indexPath: NSIndexPath) -> Bool {
        switch indexPath.row {
        case TicketCreationCells.EnterLocation.rawValue,
             TicketCreationCells.UserLocation.rawValue,
             TicketCreationCells.CurrentLocation.rawValue:
            return !isShowLocationCellsState

        default:
            return false
        }
    }

}

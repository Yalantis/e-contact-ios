//
//  TicketStateLabel.swift
//  e-contact
//
//  Created by Boris on 3/31/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class TicketStateLabel: UILabel {

    // MARK: - Public properties

    func setStatusWith(state: TicketState?) {

        guard let identifier = state?.identifier,
            ticketStateId = TicketStateId(rawValue: identifier.integerValue),
            name = state?.name else {
                return
        }
        switch ticketStateId {
        case TicketStateId.Moderation,
             TicketStateId.Denied,
             TicketStateId.Accepted,
             TicketStateId.OnReview:
            backgroundColor = UIColor.pendingColor()

        case TicketStateId.InWork:
            backgroundColor = UIColor.inProgressColor()

        case TicketStateId.Done:
            backgroundColor = UIColor.doneColor()

        }
        text = name
        sizeToFit()

    }

    // MARK: - Init

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        layer.cornerRadius = self.frame.size.height/2
        layer.masksToBounds = true
    }

}

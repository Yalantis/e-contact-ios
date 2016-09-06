//
//  ProfileFeedCell.swift
//  e-contact
//
//  Created by Igor Muzyka on 3/6/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class ProfileFeedCell: FeedBaseCell {

    static var reuseIdentifier = "ProfileFeedCell"

    override var ticket: Ticket? {
        didSet {
            if let ticket = ticket, state = ticket.state {
                var color: UIColor

                if state.identifier!.stringValue == TicketStatus.InProgress.rawValue {
                    color = UIColor.inProgressColor()
                } else if state.identifier!.stringValue == TicketStatus.Done.rawValue {
                    color = UIColor.doneColor()
                } else {
                    color = UIColor.pendingColor()
                }

                statusIndicator.backgroundColor = color
            }
        }
    }

}

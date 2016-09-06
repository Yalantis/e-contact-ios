//
//  FeedBaseCell.swift
//  e-contact
//
//  Created by Igor Muzyka on 3/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Haneke

protocol FeedCellsDelegate: class {

    func detailsButtonPressedInCell(cell: FeedBaseCell)

}

class FeedBaseCell: UITableViewCell {

    @IBOutlet internal var statusIndicator: UIView!
    @IBOutlet internal var verticalSeparator: UIView!
    @IBOutlet internal var ticketCategoryImageView: UIImageView!
    @IBOutlet internal var likeImageView: UIImageView!
    @IBOutlet internal var pinImageView: UIImageView!
    @IBOutlet internal var ticketTextLabel: UILabel!
    @IBOutlet internal var ticketLikesLabel: UILabel!
    @IBOutlet internal var ticketPublishingDateLabel: UILabel!
    @IBOutlet internal var ticketAddressLabel: UILabel!

    var delegate: FeedCellsDelegate?
    var ticket: Ticket? {
        didSet {
            guard let ticket = ticket else {
                return
            }

            if let title = ticket.title {
                ticketTextLabel.text = title
            } else {
                ticketTextLabel.text = "feedCell.choose_category".localized()
            }

            if let address = ticket.ticketAddress {
                ticketAddressLabel.text = address.localAddressString
            } else if let address = ticket.geoAddress?.name {
                ticketAddressLabel.text = address
            } else {
                ticketAddressLabel.text = "feedCell.not_ticket_address".localized()
            }

            if let createdDate = ticket.createdDate {
                ticketPublishingDateLabel.text = createdDate.dateString()
            }

            if let likesCounter = ticket.likesCounter {
                ticketLikesLabel.text = likesCounter.likesString()
            }
            if let ticketImage = ticket.category?.image {
                setCategoryImage(ticketImage)
            }
        }
    }

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUIForInitialState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        setupUIForInitialState()
    }

    // MARK: - Images

    private func setCategoryImage(image: CategoryImage) {
        guard let url = image.imagePathForScale(Constants.Scale) else {
            return
        }

        ticketCategoryImageView.hnk_setImageFromURL(url, placeholder: UIImage(named: "placeholder_icon"),
                                                    format: Constants.CategoryIconsFormat,
                                                    failure: { error in

        })
    }

}

// MARK: - UI Setup

extension FeedBaseCell {

    private func setupUIForInitialState() {
        if reuseIdentifier == FeedCell.reuseIdentifier {
            statusIndicator.hidden = true
            verticalSeparator.hidden = true
        } else if reuseIdentifier == ProfileFeedCell.reuseIdentifier {
            statusIndicator.hidden = false
            verticalSeparator.hidden = false
        } else if reuseIdentifier == DraftFeedCell.reuseIdentifier {
            statusIndicator.hidden = true
            verticalSeparator.hidden = false
        }
    }

}

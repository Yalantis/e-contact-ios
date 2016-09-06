//
//  TicketCategoryCell.swift
//  e-contact
//
//  Created by Boris on 3/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class TicketCategoryCell: UITableViewCell {

    @IBOutlet var imageViewCheck: UIImageView!
    @IBOutlet var labelTitle: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        imageViewCheck?.hidden = !selected
        if selected == true {
            labelTitle?.font = UIFont.boldApplicationFontOfSize(14)
        } else {
            labelTitle?.font = UIFont.applicationFontOfSize(15)
        }
    }

}

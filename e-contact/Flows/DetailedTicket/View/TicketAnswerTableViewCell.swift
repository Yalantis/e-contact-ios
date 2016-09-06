//
//  TicketAnswerTableViewCell.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/13/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource

class TicketAnswerTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!

}

class TicketAnswerToCellMapper: ObjectMappable {

    var cellIdentifier: String {
        get {
            return "TicketAnswerTableViewCell"
        }
    }

    func supportsObject(object: Any) -> Bool {
        return true
    }

    func mapObject(object: Any, toCell cell: Any, atIndexPath: NSIndexPath) {
        guard let tableViewCell = cell as? TicketAnswerTableViewCell,
            name = (object as? TicketAnswer)?.originName else {
            return
        }

        tableViewCell.nameLabel?.text = name
    }

}

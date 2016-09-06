//
//  AddressCell.swift
//  e-contact
//
//  Created by Illya on 3/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource

class AddressCell: UITableViewCell {

}

class AddressLocationModelToCellMapper: ObjectMappable {

    var cellIdentifier: String {
        get {
            return "AddressCell"
        }
    }

    func supportsObject(object: Any) -> Bool {
        return true
    }

    func mapObject(object: Any, toCell cell: Any, atIndexPath: NSIndexPath) {
        guard let tableViewCell = cell as? AddressCell, object = object as? AddressLocationModel else {
            return
        }

        guard let streetType = object.type?.title, title = object.title else {
            tableViewCell.textLabel?.text = object.title
            return
        }
        tableViewCell.textLabel?.text = streetType + " " + title
    }

}

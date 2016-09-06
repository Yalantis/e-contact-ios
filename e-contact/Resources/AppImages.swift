//
//  AppImages.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class AppImages: UIImage {

    static var pendingIcon: UIImage {
        return UIImage(named: "map_pin_pending")!
    }

    static var inProgressIcon: UIImage {
        return UIImage(named: "map_pin_inprogress")!
    }

    static var doneIcon: UIImage {
        return UIImage(named: "map_pin_done")!
    }

    static var filterActive: UIImage {
        return UIImage(named: "filter_active")!
    }

    static var filterDisabled: UIImage {
        return UIImage(named: "filter")!
    }

}

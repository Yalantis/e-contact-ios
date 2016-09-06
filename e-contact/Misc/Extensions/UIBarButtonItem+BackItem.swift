//
//  UIBarButtonItem+BackItem.swift
//  e-contact
//
//  Created by Igor Muzyka on 6/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let BackButtonViewSideSize = 22

extension UIBarButtonItem {

    static func BackItem(target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let image = UIImage(named: "icon_menubar_back")
        let back = UIButton(frame: CGRect(x: 0, y: 0, width: BackButtonViewSideSize, height: BackButtonViewSideSize))
        back.setImage(image, forState: .Normal)
        back.addTarget(target, action: action, forControlEvents: .TouchUpInside)

        return UIBarButtonItem(customView: back)
    }

}

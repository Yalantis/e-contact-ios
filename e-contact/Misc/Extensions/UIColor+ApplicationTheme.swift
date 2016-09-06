//
//  UIColor+ApplicationTheme.swift
//  e-contact
//
//  Created by Boris on 3/14/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIColor {

    static func applicationThemeColor() -> UIColor {
        return UIColor(red: 84/255.0, green: 125/255.0, blue: 172/255.0, alpha: 1.0)
    }

    static func applicationThemeColorShaded() -> UIColor {
        return UIColor(red: 84 / 255, green: 128 / 255, blue: 174 / 255, alpha: 0.4)
    }

    static func inProgressColor() -> UIColor {
        return UIColor(red: 248/255.0, green: 153/255.0, blue: 0.0, alpha: 1.0)
    }

    static func pendingColor() -> UIColor {
        return UIColor(red: 172 / 255, green: 172 / 255, blue: 171 / 255, alpha: 1.0)
    }

    static func doneColor() -> UIColor {
        return UIColor(red: 83 / 255, green: 175 / 255, blue: 80 / 255, alpha: 1.0)
    }

    static func redColorShaded() -> UIColor {
        return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
    }

}

//
//  UIFont+ApplicationFont.swift
//  e-contact
//
//  Created by Boris on 3/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIFont {

    static func applicationFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }

    static func boldApplicationFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }

}

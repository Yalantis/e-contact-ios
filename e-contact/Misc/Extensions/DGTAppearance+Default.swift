//
//  DGTAppearance+Default.swift
//  e-contact
//
//  Created by Boris on 3/14/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DigitsKit

extension DGTAppearance {

    static func defaultAppearance() -> DGTAppearance {
        let digitsAppearance = DGTAppearance()
        digitsAppearance.backgroundColor = UIColor.whiteColor()
        digitsAppearance.accentColor = UIColor.applicationThemeColor()
        digitsAppearance.headerFont = UIFont.applicationFontOfSize(18)
        digitsAppearance.labelFont = UIFont.applicationFontOfSize(16)
        digitsAppearance.bodyFont = UIFont.applicationFontOfSize(16)
        digitsAppearance.logoImage = UIImage(named: "AppIcon")

        return digitsAppearance
    }

}

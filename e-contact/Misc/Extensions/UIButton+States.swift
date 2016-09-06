//
//  UIButton+States.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/1/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIButton {

    func setStateActive(state: Bool = true) {
        enabled = state
        backgroundColor = state ?  UIColor.applicationThemeColor() : UIColor.applicationThemeColorShaded()
    }

}

//
//  UIAlertController+SimpleAlerts.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/1/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIAlertController {

    convenience init(simpleAlerControllerWith message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: nil, message: message, preferredStyle: .Alert)

        addAction(
            UIAlertAction(title: "simple_app.alert.error.ok_button".localized(), style: .Cancel, handler: handler)
        )
    }

    convenience init(simpleActionSheetControllerWith message: String) {
        self.init(title: nil, message: message, preferredStyle: .ActionSheet)

        addAction(UIAlertAction(title: "simple_app.alert.error.ok_button".localized(), style: .Cancel, handler: nil))
    }

}

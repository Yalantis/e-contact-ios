//
//  UIToolbar+TicketCreation.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIToolbar {

    convenience init?(item: UIBarButtonItem) {
        self.init(frame: CGRect(x: 0,
            y: UIScreen.mainScreen().bounds.size.height - Constants.TicketCreation.BarHeight,
            width: UIScreen.mainScreen().bounds.size.width,
            height: Constants.TicketCreation.BarHeight)
        )

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.barTintColor = UIColor.whiteColor()
        self.items = [flexibleSpace, item, flexibleSpace]
    }

}

//
//  ActionResponder.swift
//  e-contact
//
//  Created by Igor Muzyka on 6/6/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class ActionResponder {

    private init() { }

    @objc static func hideKeyboard() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder),
                                                     to: nil,
                                                     from: nil,
                                                     forEvent: nil)
    }

}

//
//  ResponderSwitchable.swift
//  e-contact
//
//  Created by Igor Muzyka on 6/6/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

protocol ResponderSwitchable {

    var responders: [UIResponder]? {get}

    func switchToNextResponder() -> Bool

}

extension ResponderSwitchable {

    func switchToNextResponder() -> Bool {
        guard let responders = responders else {
            return false
        }

        for (index, responder) in responders.enumerate() where responder.isFirstResponder() {
            if index < responders.count - 1 {
                let nextResponder = responders[index + 1]
                return nextResponder.becomeFirstResponder()

            } else {
                return !responder.resignFirstResponder()
            }
        }
        return false
    }

}

//
//  UserInteractionLocker.swift
//  e-contact
//
//  Created by Igor Muzyka on 6/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class UserInteractionLocker {

    private(set) static var isInterfaceAccessible: Bool = true

    private init() { }

    @objc static func lock() {
        isInterfaceAccessible = false
    }

    @objc static func unlock() {
        isInterfaceAccessible =  true
    }

}

//
//  NSNumber+LikesString.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/21/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension NSNumber {

    func likesString() -> String {
        if integerValue > 9999 {
            return "9999+"
        } else if integerValue < 0 {
            return "0"
        }

        return self.stringValue
    }

}

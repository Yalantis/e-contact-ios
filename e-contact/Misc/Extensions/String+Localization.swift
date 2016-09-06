//
//  String+Localization.swift
//  e-contact
//
//  Created by Boris on 3/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

extension String {

    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: nil,
                                 bundle: NSBundle.mainBundle(),
                                 value: "",
                                 comment: "")
    }

}

// allow String enums returns localized values
extension RawRepresentable where RawValue == String {

    func localized() -> String {
        return self.rawValue.localized()
    }

}

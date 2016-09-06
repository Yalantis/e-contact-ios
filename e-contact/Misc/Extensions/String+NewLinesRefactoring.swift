//
//  String+NewLinesRefactoring.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension String {

    func stringWithRefactoredNewLines() -> String {
        var refactored = stringByReplacingOccurrencesOfString(Constants.Regexp.NewLineTrimmer,
                                                              withString: "",
                                                              options: .RegularExpressionSearch)
        var done = false

        while !done {
            if let range = refactored.rangeOfString(Constants.Regexp.FourNewLineSybmols) {
                refactored = refactored.stringByReplacingCharactersInRange(
                    range,
                    withString: String(Constants.Regexp.ThreeNewLineSybmols)
                )
            } else {
                done = true
                break
            }
        }

        return refactored
    }

}

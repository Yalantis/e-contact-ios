//
//  Swift+TransliterationCheсk.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

extension String {

    var isLowercase: Bool {
        return self.lowercaseString == self
    }

    var isUppercase: Bool {
        return self.uppercaseString == self
    }

    var firstCharacterIsUpperCaseLetter: Bool {
        if self.isEmpty {
            return false
        }
        let firstCharacter = String(self.characters.first!)
        let firstCharacterIsLetter = firstCharacter.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil
        return firstCharacter.isUppercase && firstCharacterIsLetter
    }

    func separated(options: NSStringEnumerationOptions) -> [String] {
        let range = Range<String.Index>(self.startIndex ..< self.endIndex)
        var elements = [String]()

        self.enumerateSubstringsInRange(range, options: options) { (substring, _, _, _) -> () in
            elements.append(substring!)
        }

        return elements
    }

}

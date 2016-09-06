//
//  TransliterationManager.swift
//  e-contact
//
//  Created by Tykhonkov on 5/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

struct TransliterationRules {

    let prefixes: [String: String]?
    let combinations: [String: String]?
    let letters: [String: String]?

    init?(rulesFileName: String = "EnUaTransliteration") {
        if let rules = NSDictionary.dictionaryFromPropertyListNamed(rulesFileName) {
            prefixes = TransliterationRules.convertNSDictionaryToDictionary(
                rules.valueForKey("Prefixes") as? NSDictionary
            )
            combinations = TransliterationRules.convertNSDictionaryToDictionary(
                rules.valueForKey("Combinations") as? NSDictionary
            )
            letters = TransliterationRules.convertNSDictionaryToDictionary(
                rules.valueForKey("Letters") as? NSDictionary
            )
        } else {
            return nil
        }
    }

    static func convertNSDictionaryToDictionary(dictionary: NSDictionary?) -> [String: String]? {
        guard let dictionary = dictionary else {
            return nil
        }

        let keys = dictionary.allKeys.flatMap({$0 as? String}).sort({$0.characters.count > $1.characters.count})
        var newDictionary = [String: String]()

        for key in keys {
            if let value = dictionary[key] as? String {
                newDictionary[key] = value
            }
        }

        return newDictionary
    }

}

final class TransliterationHelper {

    private static let rules = TransliterationRules()

    static func transliterate(string: String) -> String {
        guard let rules = rules where !string.isEmpty else {
            return string
        }

        var transliteratedString: String

        if string.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet()) != nil {
            let words = string.separated(.ByWords)
            transliteratedString = ""

            words.forEach { word in
                let wordTransliteration = transliterate(word)

                if transliteratedString.isEmpty {
                    transliteratedString = wordTransliteration
                } else {
                    transliteratedString = transliteratedString + Constants.Whitespace + wordTransliteration
                }
            }
        } else {
            transliteratedString = transliterate(string, rules: rules)
        }

        if string.firstCharacterIsUpperCaseLetter {
            let uppercase = String(transliteratedString.characters.first!).uppercaseString

            transliteratedString = transliteratedString.stringByReplacingOccurrencesOfString(
                String(transliteratedString.characters.first!),
                withString: uppercase,
                options: NSStringCompareOptions.LiteralSearch,
                range: transliteratedString.startIndex..<transliteratedString.startIndex.advancedBy(1)
            )

        }
        return transliteratedString
    }

    static private func transliterate(string: String,
                               rules: TransliterationRules,
                               shouldCheckPrefixes: Bool = true,
                               shouldCheckCombinations: Bool = true) -> String {
        var transliteratedString = string

        if shouldCheckPrefixes {
            transliteratedString = operatePrefixes(of: transliteratedString, with: rules)

            return transliterate(transliteratedString,
                                 rules: rules,
                                 shouldCheckPrefixes: false,
                                 shouldCheckCombinations: true
            )
        } else if shouldCheckCombinations {
            transliteratedString = operateCombinations(of: transliteratedString, with: rules)

            return transliterate(transliteratedString,
                                 rules: rules,
                                 shouldCheckPrefixes: false,
                                 shouldCheckCombinations: false)
        } else {
            transliteratedString = operateLetters(of: transliteratedString, with: rules)

            return transliteratedString
        }
    }

    static private func operatePrefixes(of string: String, with rules: TransliterationRules) -> String {
        guard let prefixes = rules.prefixes else {
            return string
        }
        var transliteratedString = string
        let lowercase = transliteratedString.lowercaseString

        for (prefix, transliteration) in prefixes where lowercase.hasPrefix(prefix) {
            transliteratedString = transliteratedString.stringByReplacingOccurrencesOfString(
                prefix,
                withString: transliteration,
                options: NSStringCompareOptions.CaseInsensitiveSearch
            )
            break
        }

        return transliteratedString
    }

    static private func operateCombinations(of string: String, with rules: TransliterationRules) -> String {
        guard let combinations = rules.combinations else {
            return string
        }
        return trasliterate(string, with: combinations)
    }

    static private func operateLetters(of string: String, with rules: TransliterationRules) -> String {
        guard let letters = rules.letters else {
            return string
        }
        return trasliterate(string, with: letters)
    }

    static private func trasliterate(string: String, with dictionary: [String: String]) -> String {
        var transliteratedString = string.lowercaseString

        for (string, transliteration) in dictionary where transliteratedString.containsString(string) {
            transliteratedString = transliteratedString.stringByReplacingOccurrencesOfString(
                string,
                withString: transliteration,
                options: NSStringCompareOptions.CaseInsensitiveSearch
            )
        }

        return transliteratedString
    }

}

//
//  Dictionary+PropertyList.swift
//  e-contact
//
//  Created by Boris on 3/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation


extension NSDictionary {

    static func dictionaryFromPropertyListNamed(name: String) -> NSDictionary? {
        guard let filePath = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else {
            return nil
        }
        let dictionary = NSDictionary(contentsOfFile: filePath)

        return dictionary
    }

    static func configurationPropertylist() -> NSDictionary? {
        let bundle =  NSBundle.mainBundle()
        guard let plistName = bundle.objectForInfoDictionaryKey(Constants.ConfigurationPlistKey) as? String,
            plistPath = bundle.pathForResource(plistName, ofType: "plist"),
            configuration = NSDictionary(contentsOfFile: plistPath) else {
            return nil
        }
        return configuration
    }

}

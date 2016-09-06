//
//  String+NetworkHelpers.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension String {

    func isNetworkURLString() -> Bool {
        return self.hasPrefix(Constants.ImageCache.NetworkURLPrefix)

    }

    func imagePathPrefix() -> String? {

        guard let dictionary = NSDictionary.configurationPropertylist(),
            APIURLString = dictionary["API_URL"] as? String,
            APIImageFilePath = dictionary["API_FILE_PATH"] as? String else {
                return nil
        }

        return APIURLString + APIImageFilePath + self
    }

}

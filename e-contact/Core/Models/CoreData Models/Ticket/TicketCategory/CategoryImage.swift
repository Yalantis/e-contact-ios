//
//  CategoryImage.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

class CategoryImage: NSManagedObject {

    // MARK: Mapping

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "CategoryImage")
        mapping.primaryKey = "lowResolution"

        mapping.addAttributesFromDictionary([
            "lowResolution" : "40",
            "mediumResolution" : "80",
            "highResolution" : "120"
            ])

        return mapping
    }

}

extension CategoryImage {

    func imagePathForScale(scale: CGFloat) -> NSURL? {
        guard let dictionary = NSDictionary.configurationPropertylist(),
            APIURLString = dictionary["API_URL"] as? String else {
                return nil
        }
        var path = APIURLString
        var imagePath: String?
        switch scale {
        case 0.0..<2.0:
            imagePath = lowResolution

        case 2.0..<3.0:
            imagePath = mediumResolution

        case 3.0..<4.0:
            imagePath = highResolution

        default:
            return nil
        }
        guard let unwrappedImagePath = imagePath where imagePath != "" else {
            return nil
        }

        path.appendContentsOf(unwrappedImagePath)

        let url = NSURL(string: path)
        return url
    }

}

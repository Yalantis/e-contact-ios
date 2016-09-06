//
//  TicketAnswer.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/6/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

class TicketAnswer: NSManagedObject {

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "TicketAnswer")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "identifier" : "id",
            "fileName" : "filename",
            "originName" : "origin_name"
            ])

        return mapping
    }

    var fileURL: NSURL? {
        guard let dictionary = NSDictionary.configurationPropertylist(),
            APIURLString = dictionary["API_URL"] as? String,
            APIAnswerPath = dictionary["API_ANSWER_PATH"] as? String else {
                return nil
        }

        guard let filename = fileName else {
            return nil
        }
        let path = APIURLString + APIAnswerPath + filename

        return NSURL(string: path)
    }


}

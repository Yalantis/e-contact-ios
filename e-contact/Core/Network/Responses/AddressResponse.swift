//
//  AddressResponse.swift
//  e-contact
//
//  Created by Illya on 3/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping
import MagicalRecord

class AddressResponse: ResponseProtocol {

    // MARK: - Public properties

    var objects: [AddressLocationModel]?

    // MARK: - Initializer

    required init (JSON: AnyObject) {
        if let JSONArray = JSON as?  [AnyObject],
        objectsArray = FEMDeserializer.collectionFromRepresentation(JSONArray,
            mapping: AddressLocationModel.defaultMapping()) as? [AddressLocationModel] {
               self.objects = objectsArray
        }
    }

}

//
//  AddressLocationModel.swift
//  e-contact
//
//  Created by Boris on 3/11/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping

class AddressLocationModel: NSObject {

    // MARK: - Public properties

    var identifier: NSNumber?
    var title: String?
    var object: AddressLocationModel?
    var type: AddressLocationModel?

    // MARK: - Public methods

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping.addAttributesFromDictionary([
            "identifier": "id",
            "title": "name"
        ])

        mapping.addRelationshipMapping(AddressLocationModel.objectMapping(), forProperty: "object", keyPath: "district")
        mapping.addRelationshipMapping(AddressLocationModel.typeMapping(), forProperty: "type", keyPath: "street_type")

        return mapping
    }

    static func objectMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping .addAttributesFromDictionary([
            "identifier": "id",
            "title": "name"
        ])

        return mapping
    }

    static func typeMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping .addAttributesFromDictionary([
            "identifier": "id",
            "title": "short_name"
        ])

        return mapping
    }

}

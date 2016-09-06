//
//  LocalAddress.swift
//  e-contact
//
//  Created by Boris on 3/11/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping
import MagicalRecord

class LocalAddress: NSObject {

    // MARK: - Public properties

    dynamic var flat = ""

    dynamic var district: AddressLocationModel? {
        willSet {
            if let oldValueIdentifier = self.district?.identifier, newValueIdentifier = newValue?.identifier
                where !oldValueIdentifier.isEqualToNumber(newValueIdentifier) {
                    city = nil
                    street = nil
                    house = nil
                    flat = ""
            }

            self.district = newValue
        }
    }

    dynamic var city: AddressLocationModel? {
        willSet {
            if let oldValueIdentifier = self.city?.identifier, newValueIdentifier = newValue?.identifier
                where !oldValueIdentifier.isEqualToNumber(newValueIdentifier) {
                    street = nil
                    house = nil
                    flat = ""
            }

            self.city = newValue
        }
    }

    dynamic var street: AddressLocationModel? {
        willSet {
            if let oldValueIdentifier = self.street?.identifier, newValueIdentifier = newValue?.identifier
                where !oldValueIdentifier.isEqualToNumber(newValueIdentifier) {
                house = nil
                flat = ""
            }

            self.street = newValue
        }
    }

    dynamic var house: AddressLocationModel? {
        willSet {
            if let oldValueIdentifier = self.house?.identifier, newValueIdentifier = newValue?.identifier
                where oldValueIdentifier.isEqualToNumber(newValueIdentifier) {
                    flat = ""
            }

            self.house = newValue
        }
    }

    var localAddressString: String? {
        guard let
            cityTitle = city?.title,
            streetTitle = street?.title,
            streetType = street?.type?.title,
            houseTitle = house?.title else {
            return nil
        }
        var flatString = ""
        if "" != flat {
            flatString = String(format: "format.local.address_flat".localized(), flat)
        }

        return String(format: "format.local.address".localized(),
                      cityTitle,
                      streetType,
                      streetTitle,
                      houseTitle,
                      flatString)
    }


    // MARK: - Init

    // swiftlint:disable pointless_func_override
    override init() {
        super.init()
    }

    init(withAddress address: Address) {
        self.flat = address.flat ?? ""

        let districtModel = AddressLocationModel()
        districtModel.identifier = address.districtId
        districtModel.title = address.districtName
        self.district = districtModel

        let cityModel = AddressLocationModel()
        cityModel.identifier = address.cityId
        cityModel.title = address.cityName
        self.city = cityModel

        let streetModel = AddressLocationModel()
        streetModel.identifier = address.streetId
        streetModel.title = address.streetName
        streetModel.type = AddressLocationModel()
        streetModel.type!.title = address.streetType
        self.street = streetModel

        let houseModel = AddressLocationModel()
        houseModel.identifier = address.houseId
        houseModel.title = address.houseName
        self.house = houseModel
    }

    // MARK: - Public methods

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(objectClass: self)

        mapping.addAttributesFromDictionary([
            "flat": "flat",
        ])

        let districtRelationship = FEMRelationship(property: "district", keyPath: "district",
            mapping: AddressLocationModel.objectMapping())
        mapping.addRelationship(districtRelationship)

        let cityRelationship = FEMRelationship(property: "city", keyPath: "city",
            mapping: AddressLocationModel.objectMapping())
        mapping.addRelationship(cityRelationship)

        let streetRelationship = FEMRelationship(property: "street", keyPath: "street",
            mapping: AddressLocationModel.objectMapping())
        mapping.addRelationship(streetRelationship)

        let houseRelationship = FEMRelationship(property: "house", keyPath: "house",
            mapping: AddressLocationModel.objectMapping())
        mapping.addRelationship(houseRelationship)

        return mapping
    }

    func convertToAddress() -> Address? {
        guard let address = Address.MR_createEntity() else {
            return nil
        }
        address.fillWithAddress(self)
        return address
    }

}

// MARK: - NSCopying

extension LocalAddress: NSCopying {

    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = LocalAddress()
        copy.district = district
        copy.city = city
        copy.street = street
        copy.house = house
        copy.flat = flat

        return copy
    }

}

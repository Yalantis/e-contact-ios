//
//  Address.swift
//
//
//  Created by Boris on 3/10/16.
//
//

import Foundation
import CoreData
import FastEasyMapping

class Address: NSManagedObject {

    // MARK: - Public properties

    var localAddressString: String? {
        guard let cityName = cityName, streetName = streetName, houseName = houseName, streetType = streetType else {
            return nil
        }
        var flatString = ""
        if let flats = self.flat where flats != "" {
            flatString = String(format: "format.local.address_flat".localized(), flats)
        }

        return String(
            format: "format.local.address".localized(),
            cityName,
            streetType,
            streetName,
            houseName,
            flatString
        )
    }

    // MARK: - Public methods

    static func defaultMapping() -> FEMMapping {
        let mapping = FEMMapping(entityName: "Address")
        mapping.primaryKey = "identifier"

        mapping.addAttributesFromDictionary([
            "identifier": "id",
            "cityId": "city.id",
            "cityName": "city.name",
            "districtId": "district.id",
            "districtName": "district.name",
            "flat": "flat",
            "houseId": "house.id",
            "houseName": "house.name",
            "streetId": "street.id",
            "streetName": "street.name",
            "streetType": "street.street_type.short_name"
        ])

        return mapping
    }

    func fillWithAddress(address: LocalAddress) {
        flat = address.flat ?? ""

        districtId = address.district?.identifier
        districtName = address.district?.title
        cityId = address.city?.identifier
        cityName = address.city?.title
        streetId = address.street?.identifier
        streetName = address.street?.title
        streetType = address.street?.type?.title
        houseId = address.house?.identifier
        houseName = address.house?.title
    }

}

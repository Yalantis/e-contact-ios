//
//  AddressRequest.swift
//  e-contact
//
//  Created by Illya on 3/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping

enum AddressRequestType {

    case Districts, Cities(id: Int), Streets(id: Int), HousesNumbers(id: Int)

    var path: String {
        switch self {
        case .Districts:
            return "address-book/districts"

        case .Cities(let id):
            return "address-book/cities/\(id)"

        case .Streets(let id):
            return "address-book/streets/\(id)"

        case .HousesNumbers(let id):
            return "address-book/houses/\(id)"
        }
    }

}

struct AddressRequest: APIRequestProtocol {

    typealias Response = AddressResponse

    // MARK: - Public properties

    var path: String {
        return type.path
    }

    // MARK: - Private properties

    private let type: AddressRequestType

    // MARK: - Init

    init(type: AddressRequestType) {
        self.type = type
    }

}

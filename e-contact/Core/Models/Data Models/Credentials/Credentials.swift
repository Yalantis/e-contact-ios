//
//  Credentials.swift
//  e-contact
//
//  Created by Boris on 3/24/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

class Credentials: NSObject, NSCoding {

    var token: String?
    var id: NSNumber?

    // swiftlint:disable pointless_func_override
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        if let token = aDecoder.decodeObjectForKey("token") as? String {
            self.token = token
        }

        if let id = aDecoder.decodeObjectForKey("id") as? NSNumber {
            self.id = id
        }
    }

    func encodeWithCoder(aCoder: NSCoder) {
        if let token = self.token {
            aCoder.encodeObject(token, forKey: "token")
        }

        if let id = self.id {
            aCoder.encodeObject(id, forKey: "id")
        }
    }

}

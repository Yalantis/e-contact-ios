//
//  LogOutRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/24/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

struct LogOutRequest: AuthorizedAPIRequestProtocol {

    typealias Response = NullResponse

    // MARK: - Public properties

    var HTTPMethod: Method = .PUT
    var path = "logout"

}

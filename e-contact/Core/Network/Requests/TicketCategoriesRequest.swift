//
//  TicketCategoriesRequest.swift
//  e-contact
//
//  Created by Boris on 3/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import FastEasyMapping

struct TicketCategoriesRequest: APIRequestProtocol {

    typealias Response = TicketCategoriesResponse

    // MARK: - Public properties

    var path = "ticket-categories"

}

//
//  MyTicketsRequest.swift
//  e-contact
//
//  Created by Boris on 3/23/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

struct MyTicketsRequest: AuthorizedAPIRequestProtocol {

    typealias Response = TicketsResponse

    // MARK: - Public properties

    var path: String {
        return "my-tickets" + urlQuery
    }

    // MARK: - Private properties

    private var amount: Int
    private var offset: Int

    private var urlQuery: String {
        get {
            var queryString = ""

            queryString += "?&offset=" + "\(offset)"
            queryString += "&amount=" + "\(amount)"

            return queryString
        }
    }

    // MARK: - Init

    init(amount: Int = Constants.TicketsFetching.TicketsAmount,
         offset: Int = 0) {
        self.amount = amount
        self.offset = offset
    }

}

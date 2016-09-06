//
//  TicketsRequest.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation


enum OrderField: String {

    case Id = "id"
    case CompletedDate = "completed_date"
    case CreatedDate = "created_date"
    case StartDate = "start_date"
    case UpdatedDate = "updated_date"

}

enum OrderType: String {

    case Asc = "ASC"
    case Desc = "DESC"

}

struct TicketsRequest: APIRequestProtocol {

    typealias Response = TicketsResponse

    // MARK: - Private properties

    private var state: TicketStatus?
    private var title: String?
    private var categories: [TicketCategory]?
    private var orderField: OrderField = .CreatedDate
    private var orderType: OrderType = .Desc
    private var offset: Int
    private var amount: Int
    private var urlQuery: String {
        var queryString = ""

        if let state = state {
            queryString += "?state=" + state.rawValue
        } else {
            queryString += "?state=1,2,3,4,5,6"
        }

        queryString += "&order_field=" + orderField.rawValue
        queryString += "&order_type=" + orderType.rawValue
        queryString += "&offset=" + "\(offset)"
        queryString += "&amount=" + "\(amount)"

        if let titleString = title {
            queryString += "&title=" + titleString
        }

        if categories?.count > 0 {
            var categoryString = "&category="
            for category in categories! {
                categoryString += "\(category.identifier!)"
            }
            queryString += categoryString
        }

        return queryString
    }

    // MARK: - Public properties

    var path: String {
        return "tickets" + urlQuery
    }

    // MARK: - init

    init(state: TicketStatus?,
         title: String? = nil,
         categories: [TicketCategory]? = nil,
         orderField: OrderField = .CreatedDate,
         orderType: OrderType = .Desc,
         amount: Int = Constants.TicketsFetching.TicketsAmount,
         offset: Int = 0) {
        self.state = state
        self.title = title
        self.categories = categories
        self.orderField = orderField
        self.orderType = orderType
        self.amount = amount
        self.offset = offset
    }

}

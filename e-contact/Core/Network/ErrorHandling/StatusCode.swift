//
//  StatusCode.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

enum StatusCode: Int {

    case OK = 200
    case Created = 201
    case Accepted = 202
    case NoContent = 204

    case BadRequest = 400
    case BadCredentials = 401
    case AccessForbidden = 403
    case ObjectNotFound = 404

    case UnprocessableEntity = 422
    case LimitedRequest = 429

    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504

    case NoInternetConnection = -1009
    case RequestTimeout = -1001
    case InternetConnectionWasLost = -1005
    case ServerCouldNotBeFound = -1003

    var isRequestErrorCode: Bool {
        return 400..<500 ~= rawValue
    }

}

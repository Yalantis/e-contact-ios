//
//  EntityManager.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import Alamofire

class ResponseParser {

    static func parseResponse<T: APIRequestProtocol>(response: Response<AnyObject, NSError>,
                                                     request: T,
                                                     success: (T.Response -> Void)? = nil,
                                                     failure: ResponseHandler? = nil) {
        guard let JSON = response.result.value as AnyObject? else {
            return
        }

        if let statusCode = response.response?.statusCode where 200..<300 ~= statusCode {
            success?(T.Response(JSON: JSON))
        } else {
            failure?(ErrorResponse.parseError(JSON))
        }
    }

}

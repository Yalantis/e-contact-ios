//
//  APIRequestProtocol.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import Alamofire

typealias Method = Alamofire.Method

protocol APIRequestProtocol {

    associatedtype Response: ResponseProtocol

    var HTTPMethod: Method { get }
    var parameters: [String: AnyObject]? { get }
    var headers: [String: String]? { get }
    var path: String { get }

}

extension APIRequestProtocol {

    var HTTPMethod: Method { return .GET }
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String: String]? {
        return [
            "Accept":"application/json",
            "Content-Type":"application/json"
        ]
    }

}

//
//  AuthorizedAPIRequestProtocol.swift
//  e-contact
//
//  Created by Boris on 3/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthorizedAPIRequestProtocol: APIRequestProtocol {  }

extension AuthorizedAPIRequestProtocol {

    var headers: [String: String]? {

        if let token = CredentialStorage.defaultCredentialStorage().userSession?.token {
            return [
                "Accept":"application/json",
                "Content-Type":"application/json",
                "Authorization":"Bearer " + token,
            ]
        }

        return nil
    }

}

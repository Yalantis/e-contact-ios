//
//  MultipartImageUpload.swift
//  e-contact
//
//  Created by Illya on 3/31/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Alamofire

typealias MultyPartFromDataClosure = MultipartFormData -> ()

struct MultipartImageUpload: AuthorizedAPIRequestProtocol {

    typealias Response = NullResponse

    // MARK: - Public properties

    var multipartFormData: MultipartFormData -> ()
    var HTTPMethod: Method = .POST
    var path: String {
        return "ticket/\(ticketId)/file"
    }

    // MARK: - Private properties

    private var ticketId: Int

    // MARK: - Init

    init(ticketId: Int, imageData: NSData) {
        self.ticketId = ticketId

        multipartFormData = { multipartFromData in
            multipartFromData.appendBodyPart(
                data: imageData,
                name: "ticket_image",
                fileName: NSUUID().UUIDString,
                mimeType: "image/jpeg"
            )
        }
    }

}

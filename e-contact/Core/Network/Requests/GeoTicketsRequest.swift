//
//  GeoTicketsRequest.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

struct GeoTicketsRequest: APIRequestProtocol {

    typealias Response = GeoTicketsResponse

    var path = "tickets?model_size=small"

}

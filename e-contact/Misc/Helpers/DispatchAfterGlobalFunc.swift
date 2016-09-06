//
//  DispatchAfterGlobalFunc.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/26/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

func executeAfter(delay seconds: Double, closure: () -> Void) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(seconds * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)

}

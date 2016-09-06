//
//  ServiceLocator.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

class ServiceLocator {

    private var registry = [String: Any]()

    init() {}

    func registerService<T>(service: T) {
        let key = "\(T.self)"
        registry[key] = service
    }

    func getService<T>() -> T! {
        let key = "\(T.self)"
        // swiftlint:disable force_cast
        return registry[key] as! T
    }

}

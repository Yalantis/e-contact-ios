//
//  NavigationProtocol.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

protocol NavigationProtocol: class {

    weak var locator: ServiceLocator! { get }
    weak var currentViewController: UIViewController! { get }

    func popViewControllerAnimated(animated: Bool)

}

extension NavigationProtocol {

    func popViewControllerAnimated(animated: Bool = true) {
        if UserInteractionLocker.isInterfaceAccessible {
            UserInteractionLocker.lock()
            currentViewController.navigationController?.popViewControllerAnimated(animated)
        }
    }

}

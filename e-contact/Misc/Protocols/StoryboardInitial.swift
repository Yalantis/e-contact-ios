//
//  StoryboardInitial.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Foundation

protocol StoryboardInitable {

    static var storyboardName: String { get }

    static func create() -> Self

}

extension StoryboardInitable {

    static func create() -> Self {
        let identifier = String(Self)
        return UIStoryboard(
            name: storyboardName,
            bundle: nil).instantiateViewControllerWithIdentifier(identifier) as! Self // swiftlint:disable:this force_cast
    }

}

//
//  FeedSegmentedControl.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

typealias FeedSegmentedControlPageChangeHandler = (FeedPage) -> (Void)

final class FeedSegmentedControl: UISegmentedControl {

    var pageChangeHandler: FeedSegmentedControlPageChangeHandler?
    var currentPage: FeedPage {
        get {
            return FeedPage(rawValue: selectedSegmentIndex)!
        } set (value) {
            selectedSegmentIndex = value.rawValue
        }
    }

    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addTarget(self,
                  action: #selector(FeedSegmentedControl.handleValueChange),
                  forControlEvents: UIControlEvents.ValueChanged)
    }

    // MARK: - UISegmentedControl ValueChanged Action

    @objc private func handleValueChange(sender: AnyObject?) {
        if let handler = pageChangeHandler {
            handler(currentPage)
        }
    }

}

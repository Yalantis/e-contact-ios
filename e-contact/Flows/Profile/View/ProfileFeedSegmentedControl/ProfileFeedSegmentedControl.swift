//
//  ProfileFeedSegmentedControl.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/25/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

typealias ProfileFeedSegmentedControlPageChangeHandler = (ProfileFeedPage) -> (Void)

final class ProfileFeedSegmentedControl: UISegmentedControl {

    var pageChangeHandler: ProfileFeedSegmentedControlPageChangeHandler?
    var currentPage: ProfileFeedPage {
        get {
            return ProfileFeedPage(rawValue: selectedSegmentIndex)!
        } set (value) {
            selectedSegmentIndex = value.rawValue
        }
    }

    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addTarget(self,
                  action: #selector(ProfileFeedSegmentedControl.handleValueChange),
                  forControlEvents: UIControlEvents.ValueChanged)
    }

    // MARK: - UISegmentedControl ValueChanged Action

    @objc private func handleValueChange(sender: AnyObject?) {
        if let handler = pageChangeHandler {
            handler(currentPage)
        }
    }

}

//
//  FeedScrollView.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

typealias FeedScrollViewPageChangeHandler = (FeedPage) -> (Void)

final class FeedScrollView: UIScrollView, UIScrollViewDelegate {

    var pageChangeHandler: FeedScrollViewPageChangeHandler?
    var currentPage: FeedPage {
        get {
            let width = frame.size.width
            let offset = contentOffset.x
            return FeedPage(rawValue: Int(offset/width))!
        } set (value) {
            let width = frame.size.width
            let offset = width * CGFloat(value.rawValue)
            var rect = bounds
            rect.origin.x = offset
            self.scrollRectToVisible(rect, animated: true)
        }
    }

    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = self
    }

    // MARK: - UIScrollViewDelegate

    @objc func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let handler = pageChangeHandler {
            handler(currentPage)
        }
    }

}

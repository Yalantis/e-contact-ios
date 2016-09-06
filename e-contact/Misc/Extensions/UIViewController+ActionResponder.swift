//
//  UIViewController+ActionResponder.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/16/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIViewController {

    func addKeyBoardHiddingTapGestureRecognizer(with action: Selector? = nil, for target: AnyObject? = nil) {
        let keyBoardHiddingTap = UITapGestureRecognizer(target: ActionResponder.self,
                                                        action: (#selector(ActionResponder.hideKeyboard)))
        if let actions = action, target = target {
            keyBoardHiddingTap.addTarget(target, action: actions)
        }
        keyBoardHiddingTap.cancelsTouchesInView = false
        view.addGestureRecognizer(keyBoardHiddingTap)
    }

}

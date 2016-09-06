//
//  Animations.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum Alpha: CGFloat {

    case Visible = 1.0
    case Hidden = 0.0

    func reverse() -> Alpha {
        switch self {
        case .Visible:
            return .Hidden
        case .Hidden:
            return .Visible
        }
    }

}

private let AnimationDuration: NSTimeInterval = 1.0

extension UITextView {

    func applyTextWithAlphaAnimation(text: String) {
        alpha = Alpha.Hidden.rawValue
        UIView.animateWithDuration(AnimationDuration) { [weak self] in
            guard let stongSelf = self else {
                return
            }
            stongSelf.text = text
            stongSelf.alpha = Alpha.Visible.rawValue
        }
    }

}

extension UILabel {

    func applyTextWithAlphaAnimation(text: String) {
        alpha = Alpha.Hidden.rawValue
        UIView.animateWithDuration(AnimationDuration) { [weak self] in
            guard let stongSelf = self else {
                return
            }
            stongSelf.text = text
            stongSelf.alpha = Alpha.Visible.rawValue
        }
    }

}

extension UIView {

    func hideWithFadeAnimation(bool: Bool) {
        if hidden == bool {
            return
        }
        hidden = bool ? hidden : bool
        UIView.animateWithDuration(AnimationDuration, animations: { [weak self] in
            guard let stongSelf = self else {
                return
            }
            let alpha = bool ? Alpha.Visible : Alpha.Hidden

            stongSelf.alpha = alpha.rawValue
            stongSelf.alpha = alpha.reverse().rawValue
        }) { [weak self] completed in
            guard let stongSelf = self else {
                return
            }
            stongSelf.hidden = bool
        }
    }

}

//
//  TabBarView.swift
//  e-contact
//
//  Created by Igor Muzyka on 3/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

protocol TabBarViewDelegate {

    func tabBarSelectedFeed()
    func tabBarSelectedProfile()
    func tabBarSelectedNewTicket()
    var tabBar: UITabBar { get }

}

final class TabBarView: UIView {

    private let topOffsetWhenHidden: CGFloat = 60.0

    @IBOutlet private var feedButton: UIButton!
    @IBOutlet private var profileButton: UIButton!
    @IBOutlet private var newTicketButton: UIButton!
    @IBOutlet private var topSpaceConstraint: NSLayoutConstraint!

    var delegate: TabBarViewDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        self.feedButton.selected = true
    }

    // MARK: - Actions

    @IBAction func feedTouchUpInside(sender: AnyObject) {
        setFeedSelected()
        delegate?.tabBarSelectedFeed()
    }

    @IBAction func profileTouchUpInside(sender: AnyObject) {
        setProfileSelected()
        delegate?.tabBarSelectedProfile()
    }

    @IBAction func newTicketTouchUpInside(sender: AnyObject) {
        setButtonsDeselected()
        delegate?.tabBarSelectedNewTicket()
    }

    // MARK: - Presentation methods

    func show(animated: Bool = true) {
        performAnimation(animated, visible: true) { [weak self] in
            self?.topSpaceConstraint.constant = 0.0
            self?.layoutIfNeeded()
        }
    }

    func hide(animated: Bool = true) {
        performAnimation(animated, visible: false) { [weak self] in
            self?.topSpaceConstraint.constant = (self?.topOffsetWhenHidden)!
            self?.layoutIfNeeded()
        }
    }

    private func setButtonsDeselected() {
        feedButton.selected = false
        profileButton.selected = false
    }

    func setFeedSelected() {
        feedButton.selected = true
        profileButton.selected = false
    }

    func setProfileSelected() {
        feedButton.selected = false
        profileButton.selected = true
    }

    // MARK: - Helper methods

    private func performAnimation(animated: Bool, visible: Bool, animation: () -> Void) {
        layoutIfNeeded()

        delegate?.tabBar.hidden = !visible

        if animated {
            UIView.animateWithDuration(Constants.Time.TabBarAppearDisappearAnimationDuration,
                                       delay: 0.0,
                                       options: [UIViewAnimationOptions.CurveEaseInOut],
                                       animations: animation,
                                       completion: { [weak self] completed in
                if completed {
                    self?.userInteractionEnabled = visible
                }
            })
        } else {
            animation()
        }
    }

}

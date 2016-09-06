//
//  ScheduledActionsPerformer.swift
//  e-contact
//
//  Created by Igor Muzyka on 4/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class ScheduledActionsPerformer {

    private var scheduledAction: () -> Void
    private var timeInterval: NSTimeInterval
    private var timer: NSTimer?

    // MARK: - init

    init(scheduledAction: () -> Void, timeInterval: NSTimeInterval) {
        self.scheduledAction = scheduledAction
        self.timeInterval = timeInterval
    }

    // MARK: - Public methods

    func start() {
        assert(timer == nil, "you shoud stop scheduled actions performer before starting it again")

        timer = NSTimer(timeInterval: timeInterval,
                        target: self,
                        selector: #selector(performAction),
                        userInfo: nil,
                        repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)

    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private method

    @objc private func performAction() {
        self.scheduledAction()
    }

}

//
//  PushNotificationService.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping



class PushNotificationService {

    private var queue = Queue<Notification>()
    private var isShowing = false

    func handleNotification(with userInfo: [NSObject : AnyObject], isFromApplicationLaunch: Bool = false) {
        guard let notification = parseNotification(from: userInfo) where User.currentUser() != nil else {
            return
        }
        if isFromApplicationLaunch {
            executeAfter(delay: Constants.Time.ShowPushNotificationAtAppLaunchDelay, closure: { [unowned self] in
                self.queue.enQueue(notification)
                self.showNotification()
            })
        } else {
            queue.enQueue(notification)
            showNotification()
        }
    }

    private func showNotification() {
        guard let notofication = queue.top else {
            return
        }
        if let ticketIdentifier = notofication.ticketIdentifier,
            ticket = Ticket.MR_findFirstByAttribute("identifier", withValue: ticketIdentifier)
            where !AlertManager.sharedInstance.controllerIsWaitingForResponse {
            AlertManager.sharedInstance.showPushNotificationAlert(with: ticket)
            queue.deQueue()
        }
    }

    // MARK: Update Token

    func updateToken(deviceToken: NSData, apiClient: RestAPIClient) {
        if let regexp = try? NSRegularExpression(pattern: Constants.Regexp.NotWordPattern, options: .CaseInsensitive) {
            let range = NSRange(location: 0, length: deviceToken.description.characters.count)
            let tokenString = regexp.stringByReplacingMatchesInString(
                deviceToken.description,
                options: .WithTransparentBounds,
                range: range,
                withTemplate: ""
            )
            let request = UpdateTokenRequest(pushToken: tokenString)
            apiClient.executeRequest(request)
        }
    }

    // MARK: Registration

    func unregisterForRemoteNotifications() {
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
    }

    func registerUserNotificationSettings() {
        if User.currentUser() != nil {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }

    // MARK:  Parsing

    private func parseNotification(from userInfo: [NSObject : AnyObject]) -> Notification? {
        guard let aps = userInfo["aps"] as? [String: AnyObject],
            notification = FEMDeserializer.objectFromRepresentation(
                aps,
                mapping: Notification.defaultMapping()
                ) as? Notification else {
                    return nil
        }

        return notification
    }

}

extension PushNotificationService: AlertManagerSubscriptionProtocol {

    func alertManagerDidAddNewSubscriber(alertManager: AlertManager) {
        if !isShowing && !queue.isEmpty {
            isShowing = !isShowing
            executeAfter(delay: Constants.Time.ShowPushNotificationDelay) { [unowned self] in
                self.showNotification()
                self.isShowing = !self.isShowing
            }
        }
    }

}

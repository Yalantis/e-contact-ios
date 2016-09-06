//
//  AppDelegate.swift
//  e-contact
//
//  Created by Illya on 3/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import DigitsKit
import MagicalRecord
import GoogleMaps
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let router = LaunchRouter()

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let credantialStorageService: CredentialStorage = router.locator.getService()
        let pushNotificationService: PushNotificationService = router.locator.getService()
        let categoryIconsService: CategoryIconsService = router.locator.getService()
        AlertManager.sharedInstance.setSubscriptionListener(pushNotificationService)

        NSBundle.setLanguage("uk") // Forcing localization to be always ukrainian

        MagicalRecord.setupAutoMigratingCoreDataStack()

        /* There are some places which you should provide with your unique third party api key.
         Just search for "Provide your value here" in e-contact.xcodeproj and you will find it */
        GMSServices.provideAPIKey(/* Provide your value here */)
        Fabric.with([Crashlytics.self, Digits.sharedInstance()])
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)

        credantialStorageService.cleanKeychainIfNeeded()
        pushNotificationService.registerUserNotificationSettings()
        categoryIconsService.updateCategoryIcons()

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        router.execute(window!)
        window!.makeKeyAndVisible()

        return true
    }

    func application(application: UIApplication,
                     openURL url: NSURL,
                     sourceApplication: String?,
                     annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }

    // MARK: Register for push notifications

    func application(application: UIApplication,
                     didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let pushNotificationService: PushNotificationService = router.locator.getService()
        pushNotificationService.updateToken(deviceToken, apiClient: router.locator.getService())
    }

    func application(application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }

    // MARK: Handle notifications

    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let pushNotificationService: PushNotificationService = router.locator.getService()
        pushNotificationService.handleNotification(with: userInfo, isFromApplicationLaunch: true)
        completionHandler(.NewData)
    }

    // MARK: Handle badges count

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        resetBadge(application)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        resetBadge(application)
    }

    private func resetBadge(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    // MARK: - Launching Actions

    private func performInternalServicesActions() {

    }

}

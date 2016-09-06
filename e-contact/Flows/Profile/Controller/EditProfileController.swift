//
//  EditProfileController.swift
//  e-contact
//
//  Created by Boris on 3/25/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import MagicalRecord
import FBSDKLoginKit

final class EditProfileController: UIViewController, StoryboardInitable {

    static let storyboardName = "Profile"

    private var router: EditProfileRouter!
    private weak var locator: ServiceLocator!
    private var address: LocalAddress = LocalAddress()
    private var shouldUpdateAddress: Bool = false

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: EditProfileRouter) {
        self.router = router
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fillAddress()
        addAddressObserver()
        setupBackBarButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        executeEditingRequestIfNeeded()
        subscribeForAlerts()
        UserInteractionLocker.unlock()
    }

    deinit {
        address.removeObserver(self, forKeyPath: "flat")
        address.removeObserver(self, forKeyPath: "district")
        address.removeObserver(self, forKeyPath: "city")
        address.removeObserver(self, forKeyPath: "street")
        address.removeObserver(self, forKeyPath: "house")
    }

    // MARK: - Actions

    @IBAction func mainInfoTapped(recognizer: AnyObject) {
        router.showEditProfileMainInfo()
    }

    @IBAction func addressTapped(recognizer: AnyObject) {
        router.showAddressController(with: address, state: AddressControllerState.Registration)
    }

    @IBAction func changePasswordTapped(recognizer: AnyObject) {
        router.showChangePasswordController()
    }

    @IBAction func logoutTapped(recognizer: AnyObject) {
        let pushNotificationService: PushNotificationService = locator.getService()

        executeLogOutRequest()
        FBSDKLoginManager().logOut()
        removeUserData()
        pushNotificationService.unregisterForRemoteNotifications()
        router.popViewControllerAnimated()
        router.switchToFeed(tabBarController!)
    }

    // MARK: - Private Methods

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func addAddressObserver() {
        address.addObserver(self, forKeyPath: "flat", options: [], context: nil)
        address.addObserver(self, forKeyPath: "district", options: [], context: nil)
        address.addObserver(self, forKeyPath: "city", options: [], context: nil)
        address.addObserver(self, forKeyPath: "street", options: [], context: nil)
        address.addObserver(self, forKeyPath: "house", options: [], context: nil)
    }

    private func fillAddress() {
        if let user = User.currentUser(), userAddress = user.address {
            address = LocalAddress(withAddress: userAddress)
        }
    }

    private func executeLogOutRequest() {
        let apiClient: RestAPIClient = locator.getService()
        let request = LogOutRequest()

        apiClient.executeRequest(request)
    }

    private func markEditingRequestNeedsExecutionIfChangesPerformed() {
        if let user = User.currentUser(),
            userAddress = user.address,
            oldAddress = userAddress.localAddressString,
            address = address.localAddressString
            where oldAddress != address {
                shouldUpdateAddress = true
            } else {
                shouldUpdateAddress = false
            }
    }

    private func executeEditingRequestIfNeeded() {
        if shouldUpdateAddress {
            executeEditingRequest()
        }
    }

    private func executeEditingRequest() {
        if let userId = CredentialStorage.defaultCredentialStorage().userSession?.id,
            userModel = prepareUserModel() {
            let APIClient: RestAPIClient = locator.getService()
            let request = UpdateUserRequest(id: userId, user: userModel)

            AlertManager.sharedInstance.showActivity()
            APIClient.executeRequest(request, success: { [weak self] response in
                AlertManager.sharedInstance.hideActivity()
                self?.shouldUpdateAddress = false
            }, failure: { response in
                    AlertManager.sharedInstance.hideActivity()
                    AlertManager.sharedInstance.showSimpleAlert(response.message)
            })
        }
    }

    private func prepareUserModel() -> SignUpUser? {
        if let currentUser = User.currentUser() {
            let user = SignUpUser()

            user.firstName = currentUser.firstName!
            user.middleName = currentUser.middleName!
            user.lastName = currentUser.lastName!
            user.email = currentUser.email!
            user.phone = currentUser.phone!
            user.registrationAddress = address

            return user
        } else {
            return nil
        }
    }

    private func removeUserData() {
        Ticket.MR_truncateAll()
        User.removeCurrentUser()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    // MARK: - Observing

    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>) {
        markEditingRequestNeedsExecutionIfChangesPerformed()
    }

}

extension EditProfileController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}

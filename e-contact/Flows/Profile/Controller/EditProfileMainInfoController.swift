//
//  EditProfileMainInfoController.swift
//  e-contact
//
//  Created by Igor Muzyka on 5/2/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import MagicalRecord

final class EditProfileMainInfoController: UIViewController, StoryboardInitable, ResponderSwitchable {

    static let storyboardName = "Profile"
    var responders: [UIResponder]? {  return textFields }

    private var router: EditProfileMainInfoRouter!
    private weak var locator: ServiceLocator!

    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var middleNameTextField: UITextField!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet internal var textFields: [UITextField]?

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: EditProfileMainInfoRouter) {
        self.router = router
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UserInteractionLocker.unlock()
        subscribeForAlerts()
    }

    // MARK: - Setup

    private func setup() {
        addKeyBoardHiddingTapGestureRecognizer(with: #selector(enableSaveButtonIfNeeded),
                                               for: self)
        fillUserData()
        enableSaveButtonIfNeeded()
        setupBackBarButtonItem()
    }

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    // MARK: - Actions

    @IBAction func tappedSave(sender: AnyObject) {
        if validateTextFieldData() {
            self.executeEditingRequest()
        }
    }

    // MARK: - Private Methods

    @objc internal func enableSaveButtonIfNeeded() {
        if let user = User.currentUser() {
            let firstNameChanged = firstNameTextField.text! != user.firstName!
            let middleNameChanged = middleNameTextField.text! != user.middleName!
            let lastNameChanged = lastNameTextField.text! != user.lastName!
            let isButtonActive = firstNameChanged || middleNameChanged || lastNameChanged

            saveButton.setStateActive(isButtonActive)
        }
    }

    private func fillUserData() {
        if let user = User.currentUser() {
            firstNameTextField.text = user.firstName
            middleNameTextField.text = user.middleName
            lastNameTextField.text = user.lastName
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
                if response.user != nil {
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            }, failure: { response in
                    AlertManager.sharedInstance.hideActivity()
                    AlertManager.sharedInstance.showSimpleAlert(response.message)
            })
        }
    }

    private func prepareUserModel() -> SignUpUser? {
        if let currentUser = User.currentUser() {
            let user = SignUpUser()

            user.firstName = firstNameTextField.text!
            user.middleName = middleNameTextField.text!
            user.lastName = lastNameTextField.text!
            user.email = currentUser.email!
            user.phone = currentUser.phone!

            if let addressObj = currentUser.address {
                user.registrationAddress = LocalAddress(withAddress: addressObj)
            }

            return user
        } else {
            return nil
        }
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    // MARK: - Data Validation

    private func validateTextFieldData() -> Bool {

        return TextValidationHelper.validateText(firstNameTextField.text, regExp: "^.{2,30}$",
                                           message: "registration.error.first_name_validation".localized()) &&
            TextValidationHelper.validateText(middleNameTextField.text, regExp: "^.{2,30}$",
                                        message: "registration.error.middle_name_validation".localized()) &&
            TextValidationHelper.validateText(lastNameTextField.text, regExp: "^.{2,30}$",
                                        message: "registration.error.last_name_validation".localized())
    }

}

extension EditProfileMainInfoController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}

extension EditProfileMainInfoController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switchToNextResponder()
        return false
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (textField == self.firstNameTextField
            || textField == self.middleNameTextField
            || textField == self.lastNameTextField)
            && !textField.text!.isEmpty {

            if textField.text!.stringByTrimmingCharactersInSet(Constants.RussianAndUkrainianCharactersSet) == "" {
                return true
            }

            textField.text = TransliterationHelper.transliterate(textField.text!)
        }
        return true
    }

    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        enableSaveButtonIfNeeded()
        return true
    }

}

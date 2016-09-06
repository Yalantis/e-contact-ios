//
//  ChangePasswordController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/23/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class ChangePasswordController: UIViewController, StoryboardInitable, ResponderSwitchable {


    static let storyboardName = "Profile"

    var responders: [UIResponder]? { return textFields}
    private var passwordSet: PasswordsSet {
        return PasswordsSet(oldPassword: oldPasswordTextField.text!,
                            newPassword: newPasswordTextField.text!)
    }

    private var router: ChangePasswordRouter!
    private weak var locator: ServiceLocator!
    @IBOutlet private var oldPasswordTextField: UITextField!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var changePasswordButton: UIButton!
    @IBOutlet internal var textFields: [UITextField]?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
    }

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: ChangePasswordRouter) {
        self.router = router
    }

    @IBAction func executeRequest(sender: AnyObject) {
        if !validatePasswordFields() {
            return
        }

        changePasswordButton.setStateActive(false)

        let apiClient: RestAPIClient = locator.getService()
        let request = ChangePasswordRequest(passwordsSet: passwordSet)

        AlertManager.sharedInstance.showActivity()
        apiClient.executeRequest(request, success: { [weak self] response in
            self?.executeLoginRequest()
            AlertManager.sharedInstance.hideActivity()
        }) { [weak self] error in
            AlertManager.sharedInstance.hideActivity()
            if error.message == "network.error.access_forbidden".localized() {
                AlertManager.sharedInstance.showSimpleAlert("changePassword.alert.wrong_old_password".localized())
            } else {
                AlertManager.sharedInstance.showSimpleAlert(error.message.localized())
            }
            self?.changePasswordButton.setStateActive()
        }
    }

    // MARK: Private methods

    private func setup() {
        subscribeForAlerts()
        addKeyBoardHiddingTapGestureRecognizer(with: #selector(enableChangePasswordButtonIfNeeded),
                                               for: self)
        enableChangePasswordButtonIfNeeded()
        setupBackBarButtonItem()
    }

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    @objc internal func enableChangePasswordButtonIfNeeded() {
        if let oldPassword = oldPasswordTextField.text, newPassword = newPasswordTextField.text {
            changePasswordButton.setStateActive(!oldPassword.isEmpty || !newPassword.isEmpty)
        }
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func validatePasswordFields() -> Bool {

        return TextValidationHelper.validatePasswords(oldPasswordTextField.text,
                                                      newPasswordText: newPasswordTextField.text)
            && TextValidationHelper.validateText(newPasswordTextField.text,
                                                   regExp: "^.{4,20}$",
                                                   message: "changePassword.alert.password_validation".localized())
    }

    private func executeLoginRequest() {
        guard let userEmail = User.currentUser()?.email else {
            return
        }

        let apiClient: RestAPIClient = locator.getService()
        let request = UserAuthCheckRequest(username: userEmail, password: passwordSet.newPassword)

        apiClient.executeRequest(request, success: { [weak self] response in

            self?.navigationController?.popViewControllerAnimated(true)

            executeAfter(delay: Constants.Time.ChangePasswordAlertDelay) {
                AlertManager.sharedInstance.showSimpleAlert(
                    "changePassword.alert.your_password_was_changed".localized()
                )
            }
        }) { [weak self] error in
            self?.changePasswordButton.setStateActive()
            if error.message != "network.error.no_internet_connection".localized() {
                AlertManager.sharedInstance.showSimpleAlert("network.error.session_expired".localized())
            } else {
                AlertManager.sharedInstance.showSimpleAlert(error.message.localized())
            }
        }
    }

}

extension ChangePasswordController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switchToNextResponder()
        return false
    }

    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        enableChangePasswordButtonIfNeeded()
        return string.rangeOfString(Constants.Whitespace) == nil
    }

}

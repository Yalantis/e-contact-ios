//
//  LogInController.swift
//  e-contact
//
//  Created by Illya on 3/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class LoginController: UIViewController, StoryboardInitable, ResponderSwitchable {

    static let storyboardName = "Authorization"
    var responders: [UIResponder]? { return allEditableValidatingForms }
    private var router: LoginRouter!
    private var isFormValid: Bool {
        return validateTextFormsData()
    }
    private var model: LoginModel!
    @IBOutlet internal var allEditableValidatingForms: [BaseValidatingForm]?
    @IBOutlet private weak var emailValidationForm: BaseValidatingForm!
    @IBOutlet private weak var passwordValidationForm: PasswordValidatingForm!
    @IBOutlet private weak var logInButton: UIButton!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyBoardHiddingTapGestureRecognizer()
        addObserver()
        setupForms()
        setupBackBarButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        subscribeForAlerts()
        logInButton.setStateActive(isFormValid)
        UserInteractionLocker.unlock()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        clearForms()
        removeObserver()
    }

    deinit {
        removeObserver()
    }

    // MARK: - Public Methods

    func setModel(model: LoginModel) {
        self.model = model
    }

    func setRouter(router: LoginRouter) {
        self.router = router
    }

    // MARK: - Actions

    @IBAction private func login(sender: AnyObject) {
        if isFormValid {
            AlertManager.sharedInstance.showActivity()
            model.login(with: emailValidationForm.text!,
                        password: passwordValidationForm.text!,
                        success: { [weak self] in
                            AlertManager.sharedInstance.hideActivity()
                            self?.router.popViewControllerAnimated()
                }, failure: { error in
                    AlertManager.sharedInstance.hideActivity()
                    AlertManager.sharedInstance.showSimpleAlert(error.message)
            })
        } else {
            logInButton.setStateActive(false)
            AlertManager.sharedInstance.showSimpleAlert(Constants.Authorization.EmptyFields)
        }
    }

    @IBAction private func showRegistration(sender: AnyObject) {
        router.showRegistration()
    }

    @IBAction private func showPasswordRecovery(sender: AnyObject) {
        router.showPasswordRecovery()
    }

    // MARK: - Private Methods

    private func clearForms() {
        for form in allEditableValidatingForms! {
            form.text = nil
            form.hideError()
        }
    }

    private func setupForms() {
        for form in allEditableValidatingForms! {
            form.delegate = self
        }
        passwordValidationForm.textFormatingWhileEdditing = { textField, range, string in
            let trimmedString = string.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceCharacterSet().invertedSet
            )
            return trimmedString == ""
        }
    }

    @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

    @objc private func applicationDidBecomeActiveNotification() {
        logInButton.setStateActive(isFormValid)
    }

    private func validateTextFormsData() -> Bool {
        for form in allEditableValidatingForms! where !form.hasValidContent() {
            return false
        }
        return true
    }

    private func addObserver() {
        let notificationCenter = NSNotificationCenter.defaultCenter()

        notificationCenter.addObserver(self,
                                       selector: #selector(LoginController.applicationDidBecomeActiveNotification),
                                       name:UIApplicationDidBecomeActiveNotification,
                                       object:nil)
    }

    private func removeObserver() {
        let notificationCenter = NSNotificationCenter.defaultCenter()

        notificationCenter.removeObserver(self,
                                          name:UIApplicationDidBecomeActiveNotification,
                                          object:nil)
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

}


// MARK: - ValidatingFormDelegate

extension LoginController: ValidatingFormDelegate {

    func validatingFormDidShowError(validatingForm: BaseValidatingForm) {
        animateLayoutChanges()
    }

    func validatingFormDidHideError(validatingForm: BaseValidatingForm) {
        animateLayoutChanges()
    }

    func validatingFormTextFieldShouldReturn(validatingForm: BaseValidatingForm) -> Bool {
        if !switchToNextResponder() {
            login(self)
        }
        return false
    }

    private func animateLayoutChanges() {
        UIView.animateWithDuration(Constants.DefaultAnimationDuration) { [weak self] in
            self?.view.updateConstraints()
            self?.view.layoutIfNeeded()
        }
    }

    func validatingFormTextFieldDidEndEditing(validatingForm: BaseValidatingForm) {
        logInButton.setStateActive(isFormValid)
    }

}

// MARK: - NavigationControllerAppearanceContext

extension LoginController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {

        return Appearance()
    }

}

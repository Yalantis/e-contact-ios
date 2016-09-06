//
//  PasswordRecoveryController.swift
//  e-contact
//
//  Created by Illya on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class PasswordRecoveryController: UIViewController, StoryboardInitable {

    static let storyboardName = "Authorization"

    private var router: PasswordRecoveryRouter!
    private var model: PasswordRecoveryModel!
    private weak var locator: ServiceLocator!

    @IBOutlet private weak var emailValidationForm: BaseValidatingForm!
    @IBOutlet private weak var sendEmailButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupForm()
        setupBackBarButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        subscribeForAlerts()
        addKeyBoardHiddingTapGestureRecognizer()
        UserInteractionLocker.unlock()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }

    // MARK: - Public Methods

    func setModel(model: PasswordRecoveryModel) {
        self.model = model
    }

    func setRouter(router: PasswordRecoveryRouter) {
        self.router = router
    }

    // MARK: - Actions

    @IBAction private func sendEmail(sender: AnyObject) {
        if emailValidationForm.hasValidContent() {
            sendEmailButton.setStateActive(false)

            model.recoverPassword(by: emailValidationForm.text!, success: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                AlertManager.sharedInstance.showSimpleAlert(
                String(format: "password.recovery.password_has_been_sent_to_your_email".localized(),
                       strongSelf.emailValidationForm.text!)) { action in
                    strongSelf.router.popViewControllerAnimated()
                }
                }, failure: { [weak self] error in
                    if error.statusCode == StatusCode.NoInternetConnection {
                        AlertManager.sharedInstance.showSimpleAlert(error.message)
                    } else {
                        AlertManager.sharedInstance.showSimpleAlert(Constants.Authorization.WrongEmail)
                    }
                    self?.sendEmailButton.setStateActive()
            })
        } else {
            AlertManager.sharedInstance.showSimpleAlert(Constants.Authorization.EmptyFields)
        }
    }

    // MARK: - Private Methods

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

    @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func setupForm() {
        emailValidationForm.delegate = self
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

}

// MARK: - ValidatingFormDelegate

extension PasswordRecoveryController: ValidatingFormDelegate {

    func validatingFormTextFieldShouldReturn(validatingForm: BaseValidatingForm) -> Bool {
        ActionResponder.hideKeyboard()
        return true
    }

}

// MARK: - NavigationControllerAppearanceContext

extension PasswordRecoveryController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {

        return Appearance()
    }

}

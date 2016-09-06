//
//  RegistrationController.swift
//  e-contact
//
//  Created by Illya on 3/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit


final class RegistrationController: UIViewController, StoryboardInitable, ResponderSwitchable {

    static let storyboardName = "Authorization"

    var responders: [UIResponder]? { return allEditableValidatingForms }
    private var router: RegistrationRouter!
    private var address = LocalAddress()
    private var isFormValid: Bool {
        return validateTextFormsData()
    }
    private var model: RegistrationModel!

    @IBOutlet var allEditableValidatingForms: [BaseValidatingForm]?
    @IBOutlet private var allValidatingForms: [BaseValidatingForm]!
    @IBOutlet private var transliteratableValidatingForms: [BaseValidatingForm]!

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var registerButton: UIButton!

    @IBOutlet private weak var emailValidatingForm: BaseValidatingForm!
    @IBOutlet private weak var passwordValidatingForm: BaseValidatingForm!
    @IBOutlet private weak var lastNameValidatingForm: BaseValidatingForm!
    @IBOutlet private weak var firstNameValidatingForm: BaseValidatingForm!
    @IBOutlet private weak var middleNameValidatingForm: BaseValidatingForm!
    @IBOutlet private weak var addressValidatingForm: BaseValidatingForm!
    @IBOutlet private weak var phoneNumberValidatingForm: BaseValidatingForm!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupForms()
        registerButton.setStateActive(isFormValid)
        setupBackBarButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateView()
        UserInteractionLocker.unlock()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }

    @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    // MARK: - Public Methods

    func setModel(model: RegistrationModel) {
        self.model = model
        self.model.getSignUpUser = { [unowned self] in
            return self.signUpUser()
        }
    }

    func setRouter(router: RegistrationRouter) {
        self.router = router
    }

    // MARK: - Actions

    @IBAction private func registerUser(sender: AnyObject) {
        if isFormValid {
            AlertManager.sharedInstance.showActivity()
            model.executeRegistration({ [weak self] in
                    AlertManager.sharedInstance.hideActivity()
                    self?.router.pop()
                }, failure: { [weak self] response in
                    AlertManager.sharedInstance.hideActivity()
                    AlertManager.sharedInstance.showSimpleAlert(response.message)
                    if let formIsValid = self?.isFormValid {
                        self?.registerButton.setStateActive(formIsValid)
                    }
            })
        } else {
            registerButton.setStateActive(isFormValid)
            AlertManager.sharedInstance.showSimpleAlert(Constants.Authorization.EmptyFields)
        }
    }

    @IBAction private func showAddressPicker() {
        router.showAddressController(with: address, state: AddressControllerState.Registration)
    }

    @IBAction private func showTwitterDigits(sender: AnyObject) {
        self.router.showTwitterDigitsValidation() { [unowned self] session, error in

            guard let phone = session?.phoneNumber else {

                self.registerButton.setStateActive(self.isFormValid)
                return
            }

            self.phoneNumberValidatingForm.text = phone
            self.model.shouldValidatePhone = true
        }
    }

    // MARK: - Private Methods

    private func updateView() {
        fillAddressTextField()
        subscribeForAlerts()
        setupEdgesInsets()
        if model.shouldValidatePhone {
            validatePhone()
            model.shouldValidatePhone = !model.shouldValidatePhone
        }
    }

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

    private func setupForms() {
        for form in allValidatingForms {
            form.delegate = self
        }

        let tranliteration: TextFormatingAfterEdditing = { textField in
            if !textField.text!.isEmpty
                && textField.text!.stringByTrimmingCharactersInSet(Constants.RussianAndUkrainianCharactersSet)
                != "" {
                textField.text = TransliterationHelper.transliterate(textField.text!)
            }
        }

        for form in transliteratableValidatingForms {
            form.textFormatingAfterEdditing = tranliteration
        }

        passwordValidatingForm.textFormatingWhileEdditing = { textField, range, string in
            let trimmedString = string.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceCharacterSet().invertedSet
            )
            return trimmedString == ""
        }
    }

    private func setupEdgesInsets() {
        scrollView.contentInset = UIEdgeInsets(top: scrollView.contentInset.top,
                                               left:  scrollView.contentInset.left,
                                               bottom: 0,
                                               right: scrollView.contentInset.right)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func fillAddressTextField() {
        guard let localAddress = address.localAddressString else {
            return
        }

        addressValidatingForm.text = localAddress
        registerButton.setStateActive(isFormValid)
    }

    private func signUpUser() -> SignUpUser {
        let user = SignUpUser()

        user.firstName = firstNameValidatingForm.text
        user.middleName = middleNameValidatingForm.text
        user.lastName = lastNameValidatingForm.text
        user.email = emailValidatingForm.text
        user.password = passwordValidatingForm.text
        user.phone = phoneNumberValidatingForm.text
        user.registrationAddress = address

        return user
    }

    private func validateTextFormsData() -> Bool {
        for form in allValidatingForms where !form.hasValidContent() {
            return false
        }
        return model.phoneIsValid
    }

    private func handleSuccesPhoneValidation() {
        phoneNumberValidatingForm.hideError()
        registerButton.setStateActive(isFormValid)
    }

    private func validatePhone() {
        model.validatePhone({ [weak self] in
            self?.handleSuccesPhoneValidation()
        }) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            strongSelf.registerButton.setStateActive(false)
            strongSelf.phoneNumberValidatingForm.errorTitle = response.message
            strongSelf.phoneNumberValidatingForm.showError()
            strongSelf.registerButton.setStateActive(strongSelf.isFormValid)
        }
    }

}

// MARK: - NavigationControllerAppearanceContext

extension RegistrationController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {

        return Appearance()
    }

}

// MARK: - ValidatingFormDelegate

extension RegistrationController: ValidatingFormDelegate {

    func validatingFormDidShowError(validatingForm: BaseValidatingForm) {
        animateLayoutChanges()
    }

    func validatingFormDidHideError(validatingForm: BaseValidatingForm) {
        animateLayoutChanges()
    }

    func validatingFormTextFieldShouldReturn(validatingForm: BaseValidatingForm) -> Bool {
        if !switchToNextResponder() {
            showAddressPicker()
        }
        return false
    }

    func validatingFormTextFieldDidEndEditing(validatingForm: BaseValidatingForm) {
        registerButton.setStateActive(isFormValid)
    }

    private func animateLayoutChanges() {
        UIView.animateWithDuration(Constants.DefaultAnimationDuration) { [weak self] in
            self?.view.updateConstraints()
            self?.view.layoutIfNeeded()
        }
    }

}

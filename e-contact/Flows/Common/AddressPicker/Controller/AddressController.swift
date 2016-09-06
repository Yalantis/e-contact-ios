//
//  AddressController.swift
//  e-contact
//
//  Created by Illya on 3/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum AddressControllerState: String {

    case Registration
    case TicketCreation

}

final class AddressController: UIViewController, StoryboardInitable {

    static let storyboardName = "AddressPicker"

    private var router: AddressRouter!
    private var address: LocalAddress? {
        didSet {
            temporaryAddress = address!.copy() as? LocalAddress
        }
    }
    private var temporaryAddress: LocalAddress!
    private weak var locator: ServiceLocator!

    @IBOutlet private var districtField: RoundedTextField!
    @IBOutlet private var cityField: RoundedTextField!
    @IBOutlet private var streetField: RoundedTextField!
    @IBOutlet private var houseNumberField: RoundedTextField!
    @IBOutlet private var flatField: RoundedTextField!
    @IBOutlet private var districtButton: UIButton!
    @IBOutlet private var cityButton: UIButton!
    @IBOutlet private var streetButton: UIButton!
    @IBOutlet private var houseButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!

    @IBOutlet private var districtLabel: UILabel!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var streetLabel: UILabel!
    @IBOutlet private var houseLabel: UILabel!
    @IBOutlet private var flatLabel: UILabel!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.setStateActive(false)
        setupBackBarButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        subscribeForAlerts()
        setupView()
        UserInteractionLocker.unlock()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        stopEditing()
    }

    // MARK: - Public Methods

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: AddressRouter) {
        self.router = router
    }

    func setState(state: AddressControllerState) {
        switch state {
        case .Registration:
            self.title = "address_picker.title.home_address".localized()
        case .TicketCreation:
            self.title = "address_picker.title.choose_address".localized()
        }
    }

    func setAddress(address: LocalAddress?) {
        guard let address = address else {
            self.address = LocalAddress()
            return
        }
        self.address = address
    }

    // MARK: - Actions

    @IBAction func chooseDistrictAction(sender: AnyObject) {
        router.showAddressPickerWithRequest(AddressRequestType.Districts, address:temporaryAddress)
    }

    @IBAction func chooseCityAction(sender: AnyObject) {
        if let identifier = temporaryAddress.district?.identifier!.integerValue {
            router.showAddressPickerWithRequest( AddressRequestType.Cities(id:identifier), address:temporaryAddress)
        }
    }

    @IBAction func chooseStreetAction(sender: AnyObject) {
        if let identifier = temporaryAddress.city?.identifier!.integerValue {
            router.showAddressPickerWithRequest(AddressRequestType.Streets(id:identifier), address:temporaryAddress)
        }
    }

    @IBAction func chooseHouseNumberAction(sender: AnyObject) {
        if let identifier = temporaryAddress.street?.identifier!.integerValue {
            router.showAddressPickerWithRequest(AddressRequestType.HousesNumbers(id:identifier),
                                                address:temporaryAddress)
        }
    }

    @IBAction func saveResults(sender: AnyObject) {
        address?.district = temporaryAddress.district
        address?.city = temporaryAddress.city
        address?.street = temporaryAddress.street
        address?.house = temporaryAddress.house
        if flatField.text!.isEmpty || validateFlatField() {
            address?.flat = flatField.text!
            navigationController?.popViewControllerAnimated(true)
        }

    }

    // MARK: - Private Methods

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

    @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func setupEdgesInsets() {
        scrollView.contentInset = UIEdgeInsets(top: scrollView.contentInset.top,
                                           left:  scrollView.contentInset.left,
                                           bottom: 0,
                                           right: scrollView.contentInset.right)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func stopEditing() {
        view.endEditing(true)
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupView() {
        appendTextFields()
        validateTextFields()
        setupEdgesInsets()
    }

    private func validateTextFields() {
        if let bool = districtField.text?.isEmpty {
            cityButton.hideWithFadeAnimation(bool)
            cityField.hideWithFadeAnimation(bool)
            cityLabel.hideWithFadeAnimation(bool)
        }
        if let bool = cityField.text?.isEmpty {
            streetButton.hideWithFadeAnimation(bool)
            streetField.hideWithFadeAnimation(bool)
            streetLabel.hideWithFadeAnimation(bool)
        }
        if let bool = streetField.text?.isEmpty {
            houseButton.hideWithFadeAnimation(bool)
            houseNumberField.hideWithFadeAnimation(bool)
            houseLabel.hideWithFadeAnimation(bool)
        }
        if let bool = houseNumberField.text?.isEmpty {
            flatLabel.hideWithFadeAnimation(bool)
            flatField.hideWithFadeAnimation(bool)
        }

        if let bool = flatField.text?.isEmpty where !houseNumberField.text!.isEmpty {
            saveButton.setStateActive(bool)
        }

    }

    private func validateFlatField() -> Bool {

        let bool = TextValidationHelper.validateText(
            flatField.text,
            regExp: "(^[0-9]{1,4})+(([-]?)([аА-яЯ]{1})?)",
            message: "address_picker.error.fill_flat_text_field".localized()
        )
        saveButton.setStateActive(bool)
        return bool
    }

    private func appendTextFields() {
        districtField.text = temporaryAddress.district?.title
        streetField.text = temporaryAddress.street?.title
        cityField.text = temporaryAddress.city?.title
        houseNumberField.text = temporaryAddress.house?.title
        flatField.text = temporaryAddress.flat
    }

}

// MARK: - NavigationControllerAppearanceContext

extension AddressController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {

        return Appearance()
    }

}

extension AddressController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        validateFlatField()

    }

}

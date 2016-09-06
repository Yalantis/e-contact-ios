//
//  AddressPickerController.swift
//  e-contact
//
//  Created by Illya on 3/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource

final class AddressPickerController: UITableViewController, StoryboardInitable {

    static let storyboardName = "AddressPicker"

    private var router: AddressPickerRouter!

    private var type: AddressRequestType! {
        didSet {
            switch type! {
            case .Districts:
                title = "address_picker.title.choose_district".localized()
                objectType = "address_picker.object_type.district".localized()
                secondaryObjectType = "address_picker.object_type.city".localized()

            case .Cities:
                title = "address_picker.title.choose_city".localized()
                objectType = "address_picker.object_type.city".localized()

            case .Streets:
                title = "address_picker.title.choose_street".localized()

            case .HousesNumbers:
                title = "address_picker.title.choose_number".localized()
                objectType = "address_picker.object_type.number".localized()
            }
        }
    }
    private var objectType: String?
    private var secondaryObjectType: String?
    private var address: LocalAddress?
    private var adapter = TableViewAdapter <AddressLocationModel> ()
    private var array: [AddressLocationModel]? = nil {
        didSet {
            if array != nil {
                sourceArray = ArrayDataSource(objects: array!)
            }
        }
    }

    private var sourceArray: ArrayDataSource<AddressLocationModel>? {
        didSet {
            adapter.dataSource = sourceArray
            adapter.reload()
        }
    }

    private weak var locator: ServiceLocator!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        subscribeForAlerts()
        executeRequest()
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

    func setRouter(router: AddressPickerRouter) {
        self.router = router
    }

    func setType(type: AddressRequestType, address: LocalAddress) {
        self.address = address
        self.type = type
    }

    // MARK: - Private Methods

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func stopEditing() {
        view.endEditing(true)
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupController() {
        adapter.tableView = tableView
        adapter.registerMapper(AddressLocationModelToCellMapper())
        setupSelectionAction()
        setupBackBarButtonItem()
    }

    private func executeRequest() {
        let APIClient: RestAPIClient = locator.getService()
        let request = AddressRequest(type: type)
        AlertManager.sharedInstance.showActivity()

        APIClient.executeRequest(request, success: { [weak self] response  in
            AlertManager.sharedInstance.hideActivity()

            guard let objectsArray = response.objects else {
                return
            }
            self?.addTypesToObjects(objectsArray)

            }, failure: { response in
                AlertManager.sharedInstance.hideActivity()
                AlertManager.sharedInstance.showSimpleAlert(response.message)
        })
    }

    private func addTypesToObjects(addressObjects: [AddressLocationModel]) {
        switch type! {
        case .Streets:
            break
        default:
            for object in addressObjects {
                object.type = AddressLocationModel()
                switch type! {
                case .Districts where object.object != nil:
                    object.type?.title = secondaryObjectType
                default:
                    object.type?.title = objectType
                }
            }
        }
        array = addressObjects
    }

    private func setupSelectionAction() {
        adapter.didSelect = { [weak self] addressModel, index in
            self?.didSelect(addressModel)
        }
    }

    private func didSelect(model: AddressLocationModel) {
        switch type! {
        case .Districts:
            if model.object != nil {
                address?.district = model.object
                address?.city = model
            } else {
                address?.district = model
            }
        case .Cities:
            address?.city = model
        case .Streets:
            address?.street = model
        case .HousesNumbers:
            address?.house = model

        }
        navigationController?.popViewControllerAnimated(true)
    }

}

// MARK: - UISearchBarDelegate

extension AddressPickerController: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard let array = self.array else {
            return
        }
        if searchText.stringByTrimmingCharactersInSet(Constants.RussianAndUkrainianCharactersSet) != "" {
            let transliteratedText = TransliterationHelper.transliterate(searchText)
            let predicate = NSPredicate(format: "title contains[c] %@", transliteratedText)

            sourceArray =  ArrayDataSource(objects: (array.filter { (predicate.evaluateWithObject($0))}))
        } else if "" != searchText {
            let predicate = NSPredicate(format: "title contains[c] %@", searchText)
            sourceArray = ArrayDataSource(objects: (array.filter { (predicate.evaluateWithObject($0))}))
        } else {
            sourceArray = ArrayDataSource(objects: array)
        }
    }

}

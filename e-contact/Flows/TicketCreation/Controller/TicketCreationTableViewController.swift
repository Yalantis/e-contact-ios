//
//  TicketCreationTableViewController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/6/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

typealias CategoryPickerPresenterAction = (categoriesWrapper: TicketCategoryWrapper,
                                           state: CategoryPickerControllerState) -> Void
typealias AddressPickerPresenterAction = (address: LocalAddress?, state: AddressControllerState) -> Void

enum TicketCreationCells: Int {

    case Category, Location, EnterLocation, UserLocation, CurrentLocation

    var indexPath: NSIndexPath {
        return NSIndexPath(forRow: self.rawValue, inSection: 0)
    }

}

final class TicketCreationTableViewController: UITableViewController, StoryboardInitable {

    static let storyboardName = "TicketCreation"
    var changes: Changes?
    var presentAddressPicker: AddressPickerPresenterAction!
    var presentCategoryPicker: CategoryPickerPresenterAction!
    private var isFromDraft: Bool!
    private var categoryWrapper = TicketCategoryWrapper()
    private var model: TicketCreationTableModel!
    private var address = LocalAddress()
    private weak var delegate: ResizabelControllerDelegate?
    @IBOutlet private var categoryName: UILabel!
    @IBOutlet private var locationText: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCells()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        applyData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        resize()
    }

    // MARK: - Mutators

    func setModel(model: TicketCreationTableModel, delegate: ResizabelControllerDelegate) {
        self.model = model
        self.delegate = delegate
    }


    func setDataFromDraft(ticket: Ticket) {
        categoryName.text = model.ticket.category?.name
        if let addressString = model.ticket.ticketAddress?.localAddressString {
            locationSwitchValueChanged(self)
            locationText.text = addressString
        } else if let address = model.ticket.geoAddress?.name {
            locationSwitchValueChanged(self)
            locationText.text = address
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func hasValidData() -> Bool {

        if model.isShowLocationCellsState {

            return  TextValidationHelper.validateText(
                locationText.text,
                notEqual: "ticketCreation.enter_address".localized(),
                message: "ticketCreation.alerts.please_choose_address_of_ticket".localized()
            )
        } else {

            return true
        }
    }

    // MARK: TableView Methods

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return model.shouldHideCell(at: indexPath) ? Constants.TicketCreation.HidingSize : UITableViewAutomaticDimension
    }

    // MARK: - Actions

    @IBAction func locationSwitchValueChanged(sender: AnyObject) {
        model.isShowLocationCellsState = !model.isShowLocationCellsState
        let direction: UITableViewRowAnimation = model.isShowLocationCellsState ? .Bottom : .Top
        reloadLocationCells(with: direction)
    }

    @IBAction func useMyLocationTouchUpInside(sender: AnyObject) {
        if let currentUser = User.currentUser(), address = currentUser.address?.localAddressString {
            tableView.beginUpdates()
            locationText.applyTextWithAlphaAnimation(address)
            locationText.sizeToFit()
            tableView.endUpdates()
            model.ticket.ticketAddress = currentUser.address
            model.ticket.geoAddress = TicketGeoAddress.createEntityWithAddressString(address)
            applyChanges()
        }
    }

    @IBAction func chooseAddressFromMapTouchUpInside(sender: AnyObject) {
        PlacesHelper.pickPlace { [weak self] pickedAddress in
            self?.model.ticket.geoAddress = pickedAddress
            self?.tableView.beginUpdates()
            self?.locationText.applyTextWithAlphaAnimation(pickedAddress.name!)
            self?.locationText.sizeToFit()
            self?.tableView.endUpdates()
            self?.model.ticket.ticketAddress = nil
            self?.applyChanges()
        }
    }

    @IBAction func showCategoryPicker(sender: AnyObject) {
        presentCategoryPicker(categoriesWrapper: categoryWrapper, state: .TicketCreation)
    }

    @IBAction func showAddressPicker(sender: AnyObject) {
        if let latitude = model.ticket.geoAddress?.latitude?.doubleValue,
            longitude = model.ticket.geoAddress?.longitude?.doubleValue
            where latitude != 0 && longitude != 0 {
            chooseAddressFromMapTouchUpInside(self)
        } else {
            presentAddressPicker(address: address, state: .TicketCreation)
        }
    }

    // MARK: - Private Methods

    private func resize() {
        delegate?.sizeOfControllerDidChange(self, size: tableView.contentSize)
    }

    private func reloadLocationCells(with animation: UITableViewRowAnimation) {
        tableView.reloadRowsAtIndexPaths(
            [
                TicketCreationCells.UserLocation.indexPath,
                TicketCreationCells.CurrentLocation.indexPath,
                TicketCreationCells.EnterLocation.indexPath
            ],
            withRowAnimation: animation
        )
    }

    private func setupCells() {
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = Constants.TicketCreation.EstimatedRowHeight
    }

    private func applyData() {
        if let category = categoryWrapper.categories.last, text = category.name {
            tableView.beginUpdates()
            categoryName.applyTextWithAlphaAnimation(text)
            categoryName.sizeToFit()
            tableView.endUpdates()
            model.ticket.category? = category
            model.ticket.title = category.name
            applyChanges()
        }
        if let string = address.localAddressString {
            tableView.beginUpdates()
            model.ticket.ticketAddress = address.convertToAddress()
            locationText.applyTextWithAlphaAnimation(string)
            locationText.sizeToFit()
            tableView.endUpdates()
            model.ticket.geoAddress = TicketGeoAddress.createEntityWithAddressString(string)
            applyChanges()
        }
    }

    private func applyChanges() {
        changes?(true)

    }

}

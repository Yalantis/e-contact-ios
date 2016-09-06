//
//  CategoryPickerController.swift
//  e-contact
//
//  Created by Boris on 3/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource
import MagicalRecord

enum CategoryPickerControllerState: String {

    case Feed = "category_picker.title.filters"
    case TicketCreation = "category_picker.title.choose_category"

}
enum CategorySelectionState: String {

    case Some = "category.picket.navigation.bar.right.item.title.unselect_all"
    case None = "category.picket.navigation.bar.right.item.title.select_all"

}

final class CategoryPickerController: UITableViewController, StoryboardInitable {

    static let storyboardName = "CategoryPicker"

    @IBOutlet private var selectedCountLabel: UILabel!
    @IBOutlet weak var countLabelHeight: NSLayoutConstraint!

    private var selectionState = CategorySelectionState.None
    private var router: CategoryPickerRouter!
    private var fetchingId: NSNumber?
    private var adapter = TableViewAdapter<TicketCategory>()
    private var selectedCategoriesWrapper = TicketCategoryWrapper()
    private var state: CategoryPickerControllerState? {
        didSet {
            title = state?.localized()
        }
    }
    private var array: [TicketCategory]? = nil {
        didSet {
            if array != nil {
                sourceArray = ArrayDataSource(objects: array!)
            }
        }
    }

    private var sourceArray: ArrayDataSource<TicketCategory>? {
        didSet {
            self.adapter.dataSource = sourceArray
            adapter.reload()
        }
    }

    private weak var locator: ServiceLocator!
    @IBOutlet private var globalSelectionButton: UIBarButtonItem!
    @IBOutlet private var backButton: UIBarButtonItem!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
        subscribeForAlerts()
        fetchData()
    }

    // MARK: - Public Methods

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: CategoryPickerRouter) {
        self.router = router
    }

    func setCategoriesAndState(state: CategoryPickerControllerState, categoriesWrapper: TicketCategoryWrapper) {
        selectedCategoriesWrapper = categoriesWrapper
        self.state = state
    }

    // MARK: Actions

    @IBAction func doneAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func clearFilters(sender: AnyObject) {
        switch selectionState {
        case .None:
            selectAllObjects()
        case .Some:
            deselectObjects()
        }
    }

    // MARK: - Private Methods

    private func selectObjects() {
        setCellsSelected(true)
    }

    private func deselectObjects() {
        setCellsSelected(false)
    }

    private func selectAllObjects() {
        selectedCategoriesWrapper.clear()
        if let array = array {
            selectedCategoriesWrapper.categories = array
        }
        selectObjects()
    }

    private func setCellsSelected(selected: Bool) {
        selected ? () : selectedCategoriesWrapper.clear()
        let objects = selectedCategoriesWrapper.categories
        for object in objects {
            if let index = sourceArray?.indexPathOf(object) {
                tableView.selectRowAtIndexPath(index, animated: true, scrollPosition: .None)
            }
        }
        updateState()
        selected ? () : adapter.reload()
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupController() {
        tableView.estimatedRowHeight = Constants.CategoryPicker.EstimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        adapter.tableView = tableView
        adapter.registerMapper(TicketCategoryToCellMapper())
        setupSelectionActions()

        if state == .TicketCreation {
            globalSelectionButton.customView = UIView()
            backButton.title = "category_picker.back_button.title.cancel".localized()
            hideCountLabel()
        } else {
            updateState()
        }
    }

    private func hideCountLabel() {
        countLabelHeight.constant = 0
        var newFrame = tableView.tableHeaderView!.frame
        newFrame.size.height = Constants.CategoryPicker.HiddenCounterHeaderHeight
        tableView.tableHeaderView!.frame = newFrame
    }

    private func fetchData() {
        if let categories = TicketCategory.MR_findAllWithPredicate(
                NSPredicate(format: "name != nil")
            ) as? [TicketCategory]
            where !categories.isEmpty {
            array = (categories as NSArray).sortedArrayUsingComparator { object, secondObject -> NSComparisonResult in
                if let object = object as? TicketCategory, secondObject = secondObject as? TicketCategory {

                  return object.name!.localizedCaseInsensitiveCompare(secondObject.name!)
                }

                return .OrderedSame
            } as? [TicketCategory]

            if state == .Feed {
                selectObjects()
            }
        }
    }

    private func setupSelectionActions() {
        adapter.didSelect = { [weak self] ticketCategory, index in
            self?.didSelect(ticketCategory, indexPath: index)
        }

        adapter.didDeselect = { [weak self] ticketCategory, index in
            self?.didDeselect(ticketCategory, indexPath: index)
        }
    }

    private func updateState() {
        if state == .TicketCreation {
            return
        }

        if !selectedCategoriesWrapper.categories.isEmpty {
            selectionState = .Some
            globalSelectionButton.title = selectionState.localized()
            globalSelectionButton.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(17.0)],
                                                         forState: UIControlState.Normal)

            var lastDigit = selectedCategoriesWrapper.categories.count % 100

            if !(Constants.CategoryPicker.ZeroToTwentyRange ~= selectedCategoriesWrapper.categories.count) {
                lastDigit = selectedCategoriesWrapper.categories.count % 10
            }

            if lastDigit == 1 {
                selectedCountLabel.text = String(format: "format.selected.category.one".localized(),
                                                 selectedCategoriesWrapper.categories.count)
            } else if lastDigit > 0 && lastDigit < 5 {
                selectedCountLabel.text = String(format: "format.selected.category.less_than_5".localized(),
                                                 selectedCategoriesWrapper.categories.count)
            } else {
                selectedCountLabel.text = String(format: "format.selected.category.more_than_4".localized(),
                                                 selectedCategoriesWrapper.categories.count)
            }
        } else {
            selectedCountLabel.text = "format.selected.category.none".localized()
            selectionState = .None
            globalSelectionButton.title = selectionState.localized()
            globalSelectionButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)],
                                                         forState: UIControlState.Normal)
        }
    }

    private func didSelect(model: TicketCategory, indexPath: NSIndexPath) {
        selectedCategoriesWrapper.categories.append(model)
        if state == .TicketCreation {
            navigationController?.popViewControllerAnimated(true)
        }
        updateState()
    }

    private func didDeselect(model: TicketCategory, indexPath: NSIndexPath) {

        let predicate = NSPredicate(format: "identifier != %@", model.identifier!)
        selectedCategoriesWrapper.categories = selectedCategoriesWrapper.categories.filter {
            predicate.evaluateWithObject($0)
        }
        updateState()
    }

}

// MARK: - UISearchBarDelegate

extension CategoryPickerController: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard let array = self.array else {
            return
        }
        if searchText.characters.count > 0 {
            var predicate: NSPredicate
            let predicateFormat = "name contains[c] %@"

            if searchText.stringByTrimmingCharactersInSet(Constants.RussianAndUkrainianCharactersSet) != "" {
                let transliteratedText = TransliterationHelper.transliterate(searchText)
                searchBar.text = transliteratedText
                predicate = NSPredicate(format: predicateFormat, transliteratedText)
            } else {
                predicate = NSPredicate(format: predicateFormat, searchText)
            }

            sourceArray =  ArrayDataSource(objects: (array.filter { (predicate.evaluateWithObject($0))}))
        } else {
            sourceArray = ArrayDataSource(objects: array)
        }
        setCellsSelected(true)
    }

}

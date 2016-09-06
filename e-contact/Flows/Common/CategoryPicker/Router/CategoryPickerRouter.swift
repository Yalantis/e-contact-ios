//
//  CategoryPickerRouter.swift
//  e-contact
//
//  Created by Boris on 3/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class CategoryPickerRouter: AlertManagerDelegate, CategoryPickerPresenter, FeedPresenter {

    private(set) var categoriesWrapper: TicketCategoryWrapper
    private(set) var state: CategoryPickerControllerState
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, categoriesWrapper: TicketCategoryWrapper, state: CategoryPickerControllerState) {
        self.locator = locator
        self.state = state
        self.categoriesWrapper = categoriesWrapper
    }

}

extension CategoryPickerRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = CategoryPickerController.create()
        controller.setRouter(self)
        controller.setCategoriesAndState(state, categoriesWrapper: categoriesWrapper)
        controller.setLocator(locator)
        currentViewController = controller
        context.showViewController(controller, sender: self)
        return nil
    }

}

protocol CategoryPickerPresenter: NavigationProtocol {

    func showCategoryPicker(with categoriesWrapper: TicketCategoryWrapper,
                                 state: CategoryPickerControllerState)

}

extension CategoryPickerPresenter {

    func showCategoryPicker(with categoriesWrapper: TicketCategoryWrapper, state: CategoryPickerControllerState) {
        let categoryPickerRouter = CategoryPickerRouter(locator: locator,
                                                        categoriesWrapper: categoriesWrapper,
                                                        state: state)

        categoryPickerRouter.execute(currentViewController.navigationController!)
    }

}

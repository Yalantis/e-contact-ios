//
//  TicketAnswersController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource
import SafariServices
import WebKit

final class TicketAnswersController: UIViewController, StoryboardInitable {

    static let storyboardName = "DetailedTicket"

    private var ticket: Ticket! {
        didSet {
            title = "ticketAnswer.controller.title".localized()
        }
    }
    private var router: TicketAnswersRouter!
    private var adapter = TableViewAdapter<TicketAnswer>()
    private var sourceArray: ArrayDataSource<TicketAnswer>? {
        didSet {
            adapter.dataSource = sourceArray
            adapter.reload()
        }
    }
    private weak var locator: ServiceLocator!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackBarButtonItem()
        setupAdapter()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        subscribeForAlerts()
    }

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: TicketAnswersRouter) {
        self.router = router
    }

    func setTicket(ticket: Ticket) {
        self.ticket = ticket
    }

    // MARK: - Private methods

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupAdapter() {
        guard let answers = ticket.answers?.allObjects as? [TicketAnswer] else {
            return
        }
        tableView.estimatedRowHeight = Constants.CategoryPicker.EstimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        adapter.tableView = tableView
        adapter.registerMapper(TicketAnswerToCellMapper())
        adapter.didSelect = { [weak self] ticketAnswer, index in
            self?.didSelect(ticketAnswer)
        }

        sourceArray = ArrayDataSource(objects: answers.sort {
            guard let firstItemIdentifier = $0.identifier?.integerValue,
                      secondItemIdentifier = $1.identifier?.integerValue else {
                return false
            }
            return firstItemIdentifier > secondItemIdentifier
        })
    }

    private func didSelect(ticketAnswer: TicketAnswer) {
        guard let url = ticketAnswer.fileURL else {
            AlertManager.sharedInstance.showSimpleAlert("ticketAnswer.alert.answer_unavailable".localized())
            return
        }

        if #available(iOS 9.0, *) {
            let safari = SFSafariViewController(URL: url)
            safari.navigationItem.backBarButtonItem?.title = ""
            safari.title = ticketAnswer.originName
            self.navigationController?.showViewController(safari, sender: self)
        } else {
            router.showWebView(url)
        }
    }

}

//
//  DetailedTicketController.swift
//  e-contact
//
//  Created by Boris on 3/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import MagicalRecord
import FBSDKLoginKit

enum DetailedTicketRow: Int {

    case Category = 0,
    PerformerComments,
    PerformerAnswer,
    CreatedDate,
    RegisteredDate,
    DeadLine,
    Completion,
    Address,
    Performer,
    Content,
    Images

}

enum DetailedTicketFrom {

    case Map, PushNotification, TicketsList

}

final class DetailedTicketController: UITableViewController, StoryboardInitable {

    static let storyboardName = "DetailedTicket"

    private var router: DetailedTicketRouter!
    private var overlayingView: UIView?
    private var model: DetailedTicketModel!

    @IBOutlet private weak var ticketTitleLabel: UILabel!
    @IBOutlet private weak var ticketStateLabel: TicketStateLabel!
    @IBOutlet private weak var likeCounterLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var deadlineDateLabel: UILabel!
    @IBOutlet private weak var registrationDateLabel: UILabel!
    @IBOutlet private weak var completionDateLabel: UILabel!
    @IBOutlet private weak var ticketAddressLabel: UILabel!
    @IBOutlet private weak var managerNameLabel: UILabel!
    @IBOutlet private weak var ticketContentLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var imagesCollection: UICollectionView!
    @IBOutlet private weak var imagesTableCell: ImagesTableCell!
    @IBOutlet private weak var showMapButton: UIButton!
    @IBOutlet private weak var showMapAccessoryArrow: UIImageView!
    @IBOutlet private weak var stateLabelWidthConstraint: NSLayoutConstraint!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeForAlerts()
        setup()
        updateTicket()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
        setupEdgesInsets()
        subscribeForAlerts()
    }

    // MARK: - Mutators

    func setModel(model: DetailedTicketModel) {
        self.model = model
    }

    func setRouter(router: DetailedTicketRouter) {
        self.router = router
    }

    // MARK: - Actions

   @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    @IBAction private func showTicketAnswer(sender: AnyObject) {
        if let ticket = model.ticket {
            if UserInteractionLocker.isInterfaceAccessible {
                UserInteractionLocker.lock()
                router.showTicketAnswers(ticket)
            }
        }
    }

    @IBAction private func showTicketLocation(sender: AnyObject) {
        if let ticket = model.ticket {
            if UserInteractionLocker.isInterfaceAccessible {
                UserInteractionLocker.lock()
                router.showMap(ticket)
            }
        }
    }

    @IBAction private func showPerformerComments(sender: AnyObject) {
        presentAlertController()
    }

    @IBAction private func likeAction(sender: AnyObject) {
        if  User.currentUser() != nil {
            shouldLike()
        } else {
            router.showLogin()
        }
    }

    //MARK: - Private Methods

    private func setup() {
        if model.from == .PushNotification {
            router.hideTabBar(true)
        }
        if model.ticketIdentifier != nil && model.ticket == nil {
            overlayingView = UIView(frame: view.bounds)
            overlayingView!.backgroundColor = UIColor.whiteColor()
            view.addSubview(overlayingView!)

            AlertManager.sharedInstance.showActivity()
        }
        setupTableView()
        setDataFromTicket()
        setStateForShowMapButton()
        setupBackBarButtonItem()
    }

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

    private func updateTicket() {
        model.updateTicket({ [weak self] in
                AlertManager.sharedInstance.hideActivity()
                self?.setDataFromTicket()
            }, failure: { [weak self] in
                AlertManager.sharedInstance.hideActivity()
                guard let strongSelf = self else {
                    return
                }
                switch strongSelf.model.from! {
                case .Map:
                    AlertManager.sharedInstance.showSimpleAlert("detailedTicket.ticket_update_failure".localized(),
                        handler: { [weak self] action in
                            self?.router.popViewControllerAnimated()
                    })
                case .PushNotification:
                    AlertManager.sharedInstance.showSimpleAlert("detailedTicket.ticket_update_failure".localized())
                default:
                    break
                }
        })
    }

    private func setupEdgesInsets() {
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                              left:  tableView.contentInset.left,
                                              bottom: 0,
                                              right: tableView.contentInset.right)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    private func shouldLike() {
        guard let fbToken = FBSDKAccessToken.currentAccessToken(),
            identifier = model.ticket?.identifier?.integerValue else {
            loginToFaceBook()
            return
        }
        model.likeTicket(with: identifier,
                         facebookTokenString: fbToken.tokenString,
            success: { [weak self] in
                self?.updateTicket()
                self?.likeButton.enabled = true
            }) { [weak self] error in
                if error.statusCode.isRequestErrorCode {
                    AlertManager.sharedInstance.showSimpleAlert("detailedTicket.like.message".localized())
                } else {
                    AlertManager.sharedInstance.showSimpleAlert(error.message)
                }
                self?.likeButton.enabled = true
        }
    }

    private func loginToFaceBook() {
        let login = FBSDKLoginManager()

        login.logInWithReadPermissions(["email"], fromViewController: self) {
            [weak self] (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            if error != nil {
                FBSDKLoginManager().logOut()
            } else if result.isCancelled {
                FBSDKLoginManager().logOut()
            } else {
                self?.shouldLike()
            }
        }
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

     private func setDataFromTicket() {
        if let ticket = model.ticket {
            if let ticketId = ticket.ticketId {
                title = String(format: "ticketCreation.ticket".localized(), ticketId)
            } else {
                title = "ticketCreation.ticket".localized()
            }
            registrationDateLabel.text = ticket.startedDate?.dateString()
            deadlineDateLabel.text = ticket.deadline?.dateString()
            completionDateLabel.text = ticket.completedDate?.dateString()
            if let addressString = ticket.ticketAddress?.localAddressString {
                ticketAddressLabel.text = addressString
            } else if let addressString = ticket.geoAddress?.name {
                ticketAddressLabel.text = addressString
            }
            managerNameLabel.text = ticket.performersString
            if let imagesPaths = ticket.imagesPaths where !imagesPaths.isEmpty {
                imagesTableCell.setImagesPaths(imagesPaths)
            }
            ticketContentLabel.text = ticket.body
            createdDateLabel.text = ticket.createdDate?.dateString()
            ticketStateLabel.setStatusWith(ticket.state)
            stateLabelWidthConstraint.constant = (
                ticketStateLabel.frame.width + Constants.DetailedTicket.StateLAbelWidthInsets
            )
            ticketTitleLabel.text = ticket.title
            likeCounterLabel.text = ticket.likesCounter?.likesString()

            reloadTableViewContentsAndAnimateIfNeeded()
        }
    }

    private func reloadTableViewContentsAndAnimateIfNeeded() {
        tableView.reloadData()

        if model.ticketIdentifier != nil && model.ticket != nil {
            UIView.animateWithDuration(Constants.DefaultAnimationDuration, animations: { [weak self] in
                self?.overlayingView?.alpha = 0.0
            })
        }
    }

    private func setStateForShowMapButton() {
        if let ticket = model.ticket {
            let bool = ticket.geoAddress?.latitude == nil || ticket.geoAddress?.longitude == nil
            showMapButton.hidden = bool
            showMapAccessoryArrow.hidden = bool
        }
    }

    private func setupTableView() {
        imagesTableCell.setImagesCollectionViewAndDelegate(imagesCollection, delegate: self)
        tableView.estimatedRowHeight = Constants.TicketCreation.EstimatedRowHeight
    }

    private func presentAlertController() {
        if let ticket = model.ticket {
            let action = UIAlertAction(title: "detailedTicket.alert.comment_accepted".localized(),
                                       style: .Default,
                                       handler: nil)
            let alertController = UIAlertController(title: "detailedTicket.alert.comment_alert_title".localized(),
                                                message: ticket.comment,
                                                preferredStyle: .Alert )

            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - UITableViewDelegate override

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  model.shouldHideCell(at: indexPath)
            ? Constants.TicketCreation.HidingSize
            : UITableViewAutomaticDimension
    }

}

// MARK: - NavigationControllerAppearanceContext

extension DetailedTicketController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}

extension DetailedTicketController: ImagesTableCellDelegate {

    func imagesTableCellDidSelectObjectWith(diskPath: String, indexPath: NSIndexPath) {
        guard let imagePaths = model.ticket?.imagesPaths else {
            return
        }
        router.showImagesGalleryWithImagesPaths(imagePaths, focusedIndexPath: indexPath, ticketTitle: self.title)
    }

}

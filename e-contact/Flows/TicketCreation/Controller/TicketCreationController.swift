//
//  TicketCreationController.swift
//  e-contact
//
//  Created by Illya on 3/25/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

typealias Changes = Bool -> Void

protocol ResizabelControllerDelegate: class {

    func sizeOfControllerDidChange(viewController: UIViewController, size: CGSize)

}

enum TicketCreationControllerSegueIdentifiers: String {

    case TicketCreationImages = "TicketCreationImagesControllerSegue"
    case TicketCreationTable = "TicketCreationTableViewControllerSegue"

}

final class TicketCreationController: UIViewController, StoryboardInitable {

    static let storyboardName = "TicketCreation"
    private let imagesGalleryHeightConstant: CGFloat = 140
    private var model: TicketCreationModel!
    private var textViewHeightConstant: CGFloat!
    private var isChanged = false
    private var router: TicketCreationRouter!
    private var photoToolbar: UIToolbar!
    private var actionAlertController: UIAlertController!
    private var backButtonAlertController: UIAlertController!
    private var imagesUploadingAlertController: UIAlertController!
    private var ticketCreationImagesController: TicketCreationImagesController!
    private var tableViewController: TicketCreationTableViewController!
    private var photoDeletionPathHolder: String?
    @IBOutlet weak private var tableViewControllerContainer: UIView!
    @IBOutlet weak private var imagesControllerContainer: UIView!
    @IBOutlet weak private var imagesControllerContainerHeight: NSLayoutConstraint!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var ticketDescription: UITextView!
    @IBOutlet weak private var sendButton: UIBarButtonItem!
    @IBOutlet weak private var tableViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak private var textViewHeightConstraint: NSLayoutConstraint!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        subscribeForAlerts()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        addPhotoToolBar()
        animateLayoutWithDuration(Constants.TicketCreation.ImagesGalleryAnimatonDuration)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
        photoToolbar?.removeFromSuperview()
    }

    // MARK: - Public Methods

    func setModel(model: TicketCreationModel) {
        self.model = model
        self.model.imagesUploadingProgress = { [weak self] message in
            self?.imagesUploadingAlertController.message = message
        }
        self.model.imageUploadCompletion = { [weak self] in
            self?.dismissViewControllerAnimated(true) { [weak self] in
                self?.handleSuccess()
            }
        }
        self.model.imagesPathsChanges = { [unowned self] imagesPaths in
            guard let imagesPaths = imagesPaths else {
                return
            }
            self.ticketCreationImagesController?.update(imagesPaths)

            if imagesPaths.isEmpty
                && self.imagesControllerContainerHeight.constant
                != Constants.TicketCreation.HidingSize {
                self.imagesControllerContainerHeight.constant = Constants.TicketCreation.HidingSize
                self.animateLayoutWithDuration(Constants.TicketCreation.ImagesGalleryAnimatonDuration)
            } else if self.imagesControllerContainerHeight.constant != self.imagesGalleryHeightConstant {
                self.imagesControllerContainerHeight.constant = self.imagesGalleryHeightConstant
                self.animateLayoutWithDuration(Constants.TicketCreation.ImagesGalleryAnimatonDuration)
                self.scrollView.setContentOffset(CGPoint(x: 0, y: CGFloat.max), animated: true)
            }
        }
    }

    func setRouter(router: TicketCreationRouter) {
        self.router = router
    }

    // MARK: - Private Methods

    private func setupUI() {
        setupChildControllers()
        if model.isFromDraft {
            fill(with: model.ticket)
        }
        self.router.hideTabBar(true)
        addKeyBoardHiddingTapGestureRecognizer()
        setupAlertsControllers()
        textViewHeightConstant = textViewHeightConstraint.constant
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func isTicketValid() -> Bool {
        return TextValidationHelper.validateText(model.ticket.category!.name,
                                          message: "ticketCreation.alerts.please_choose_category_of_ticket".localized())
        && tableViewController.hasValidData()
        && TextValidationHelper.validateText(model.ticket.body,
                                       notEqual: "ticketCreation.describe_problem".localized(),
                                       message: "ticketCreation.alerts.please_fill_description_of_ticket".localized())
    }

    private func addPhotoToolBar() {
        let item = UIBarButtonItem(title: Constants.TicketCreation.AddPhoto,
                                   style: .Plain,
                                   target: self,
                                   action: (#selector(takePhoto)))
        photoToolbar = UIToolbar(item: item)
        tabBarController?.view.addSubview(photoToolbar)
    }

    private func setupAlertsControllers() {
        initAlertControllers { [weak self] actionType in
            guard let this = self else {
                return
            }
            switch actionType {
            case .DeletePhoto:
                this.model.deletePhotoWithPath(this.photoDeletionPathHolder!)

            case .SaveToDraft:
                this.model.saveTicketToDraft()
                this.router.backToRootViewController()


            case .DoNotSaveTicket:
                if !this.model.isFromDraft {
                    this.deleteCachedImagesAndTicket()
                }
                this.router.backToRootViewController()

            case .StopUploading:
                this.model.cancelPhotoUploading()
                this.dismissViewControllerAnimated(true, completion: nil)
                this.router.popViewControllerAnimated()
                AlertManager.sharedInstance.showAlertAfter(
                    delay: Constants.Time.TicketCreationAlertDelay,
                    with: "ticketCreation.ticket.uploaded_without_photo".localized())

            default:
                break
            }
        }
    }

    private func initAlertControllers(handler: (TicketCreationAction) -> ()) {
        actionAlertController = UIAlertController(actionAlertContrtoler: handler)
        backButtonAlertController = UIAlertController(backButtonAlertController: handler)
        imagesUploadingAlertController = UIAlertController(imageUploadingAllertController: handler)
    }

    private func fill(with draftTicket: Ticket) {
        model.fetchChachedImgesPaths()
        tableViewController.setDataFromDraft(draftTicket)
        ticketDescription.text = draftTicket.body
    }

    private func setupChildControllers() {
        let changes: Changes = { [weak self] bool in
            self?.isChanged = bool
        }
        tableViewController = router.loadTableViewController(self,
                                                             ticket: model.ticket,
                                                             isFromDraft: model.isFromDraft,
                                                             changes: changes)
        showChildController(tableViewController, in: tableViewControllerContainer)
        ticketCreationImagesController = router.loadImagesController(self,
                                                                     ticket: model.ticket,
                                                                     changes: changes)
        showChildController(ticketCreationImagesController, in: imagesControllerContainer)
    }

    private func showChildController(childViewController: UIViewController, in containerView: UIView) {
        childViewController.view.frame = containerView.bounds

        addChildViewController(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.didMoveToParentViewController(self)
    }

    private func deleteCachedImagesAndTicket() {
        model.deleteCachedImages()
        model.deleteTicket()
    }

    @objc private func takePhoto() {
        ticketCreationImagesController?.startPickingImages()
    }

    private func executeTicketUploading() {
        sendButton.enabled = false
        model.executeTicketUploading({ [unowned self] uploadingType in
            switch uploadingType {
            case .WithImages(let message):
                self.imagesUploadingAlertController.message = message
                self.presentViewController(self.imagesUploadingAlertController, animated: true, completion: nil)
                self.sendButton.enabled = false
            case .WithoutImages:
                self.handleSuccess()
            }
            }) { [unowned self] in
                AlertManager.sharedInstance.showSimpleAlert(
                    "ticketCreation.request.error_while_sending_ticket".localized()
                )
                self.sendButton.enabled = true
        }
    }

    private func handleSuccess() {
        AlertManager.sharedInstance.showAlertAfter(delay: Constants.Time.TicketCreationAlertDelay,
                                                   with: "ticketCreation.your_ticket_was_sent".localized())
        deleteCachedImagesAndTicket()
        navigationController?.popViewControllerAnimated(true)
    }

    private func animateLayoutWithDuration(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] completed in
            if completed {
                self?.ticketCreationImagesController.collectionView?.reloadData()
            }
        }
    }

    // MARK: - Actions

    @IBAction func sendTicket(sender: AnyObject) {
        ticketDescription.resignFirstResponder()
        isTicketValid() ? executeTicketUploading() : ()
    }

    @IBAction func backButtonAction(sender: AnyObject) {
        if isChanged || model.isFromDraft {
            presentViewController(backButtonAlertController!, animated: true, completion: nil)
        } else {
            model.deleteTicket()
            router.backToRootViewController()
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        ticketDescription.endEditing(true)
    }

}

// MARK: - TextViewDelegate methods

extension TicketCreationController: UITextViewDelegate {

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        photoToolbar.removeFromSuperview()
        ticketDescription.inputAccessoryView = photoToolbar
        if textView.text == "ticketCreation.describe_problem".localized() {
            isChanged = true
            textView.textColor = UIColor.blackColor()
            textView.text = nil
        }

        return true
    }

    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.textColor = UIColor.grayColor()
            textView.text = "ticketCreation.describe_problem".localized()
        } else {
            isChanged = true
            textView.text = textView.text.stringWithRefactoredNewLines()
            textViewDidChange(textView)
            model.ticket.body = textView.text
        }
        ticketDescription.inputAccessoryView = nil
        addPhotoToolBar()

        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let summaryCharactersCount = textView.text.characters.count + text.characters.count

        return summaryCharactersCount < Constants.TicketCreation.TicketDescriptionMaxCharactersCount
    }

    func textViewDidChange(textView: UITextView) {
        let oldHeight =  textViewHeightConstraint.constant
        let height = textView.intrinsicContentSize().height
        if height > textViewHeightConstant && height != oldHeight {
            textViewHeightConstraint.constant = height
        }
        animateLayoutWithDuration(Constants.TicketCreation.TextViewResizingAnimationDuration)
    }

}

// MARK: - TicketCreationImagesControllerDelegate

extension TicketCreationController: TicketCreationImagesDelegate {

    func ticketCreationImagesController(ticketCreationImagesController: TicketCreationImagesController,
                                        didSelect object: String,
                                        at IndexPath: NSIndexPath) {
        photoDeletionPathHolder = object
        presentViewController(actionAlertController!, animated:true, completion: nil)

    }

    func ticketCreationImagesController(ticketCreationImagesController: TicketCreationImagesController,
                                        didPickImage image: UIImage) {
        model.saveAndResizeImage(image)
    }

}

// MARK: - NavigationControllerAppearanceContext delegate methods

extension TicketCreationController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}

// MARK: - ResizableControlerDelegate

extension TicketCreationController: ResizabelControllerDelegate {

    func sizeOfControllerDidChange(viewController: UIViewController, size: CGSize) {
        if viewController.isEqual(tableViewController) {
            tableViewContainerHeight.constant = size.height
        }
        animateLayoutWithDuration(Constants.TicketCreation.AddressCellsAnimationDuration)
    }

}

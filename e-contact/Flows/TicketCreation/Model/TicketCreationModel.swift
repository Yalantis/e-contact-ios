//
//  TicketCreationModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/12/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import MagicalRecord

enum TicketUplopadingType {

    case WithImages(message: String)
    case WithoutImages

}

typealias ImageUploadCompletion = () -> Void
typealias ImagesUploadingProgress = String -> Void
typealias ImagePathsChanges = [String]? -> Void

class TicketCreationModel {

    var ticket: Ticket!
    var imageUploadCompletion: ImageUploadCompletion!
    var imagesUploadingProgress: ImagesUploadingProgress!

    var imagesPathsChanges: ImagePathsChanges?
    private(set) var isFromDraft = false
    private(set) weak var locator: ServiceLocator!
    private var imagesPathsToUpload: [String]?
    private var photoUploadingIsCanceled = false
    private(set) var imagesPaths = [String]() {
        didSet {
            imagesPathsChanges?(imagesPaths)
        }
    }

    init(ticket: Ticket?, locator: ServiceLocator) {
        self.locator = locator
        guard let ticket = ticket else {
            self.ticket = createTicket()
            return
        }
        self.ticket = ticket
        isFromDraft = true
    }

    func deleteTicket() {
        ticket.MR_deleteEntity()
    }

    func executeTicketUploading(success: TicketUplopadingType -> Void, failure: () -> Void) {
        let APIClient: RestAPIClient = locator.getService()
        let request = TicketCreationRequest(ticket: ticket)

        APIClient.executeRequest(request, success: { [unowned self] response in
            guard let ticketIdentifer = response.ticketId else {
                return
            }
            if self.imagesPaths.count > 0 {
                let message = String(format: "format.imges.uploading.bar.message".localized(),
                    String(1),
                    String(self.imagesPaths.endIndex))

                success(TicketUplopadingType.WithImages(message: message))
                self.uploadTicketImagesWithTicketIdenifier(ticketIdentifer)
            } else {
                success(TicketUplopadingType.WithoutImages)
            }
        }) { error in
            failure()
        }
    }

    private func uploadTicketImagesWithTicketIdenifier(identifier: Int) {
        imagesPathsToUpload = imagesPaths
        uploadTicketImages(with: identifier)
    }

    func fetchChachedImgesPaths() {
        if let imagesPaths = ticket.fetchCachedImagesPath() {
            self.imagesPaths = imagesPaths
        }
    }

    func cancelPhotoUploading() {
        photoUploadingIsCanceled = true
        let apiClient: RestAPIClient = locator.getService()
        apiClient.stopAllRequests()
    }

    func deletePhotoWithPath(path: String) {
        let imageChacheSerive: ImageCachingService = locator.getService()
        let predicate = NSPredicate(format: "SELF != %@", path)
        self.imagesPaths = imagesPaths.filter {
            predicate.evaluateWithObject($0)
        }
        imageChacheSerive.removeTicketCreationImage(at: path)
    }

    func deleteCachedImages() {
        for path in imagesPaths {
            deletePhotoWithPath(path)
        }
    }

    func saveAndResizeImage(image: UIImage) {
        let imageChacheService: ImageCachingService = locator.getService()

        imageChacheService.saveAndResizeTicketCreationImage(image) { [weak self] diskPath in
            self?.imagesPaths.append(diskPath)
        }
    }

    private func uploadTicketImages(with identifier: Int) {
        guard let path = imagesPathsToUpload?.first where !photoUploadingIsCanceled else {
            imageUploadCompletion()
            imagesPathsToUpload = nil
            return
        }
        let apiClient: RestAPIClient = locator.getService()
        let cachingService: ImageCachingService = locator.getService()
        cachingService.loadTicketCreationImageData(from: path, success: { imageData in
            let method = MultipartImageUpload(ticketId: identifier, imageData: imageData)

            apiClient.executeMultipartUpload(method, success: { [weak self] success in
                self?.imagesPathsToUpload!.removeFirst()
                if let imageIndex = self?.imagesPaths.indexOf(path), endIndex = self?.imagesPaths.endIndex {
                    let message = String(format: "format.imges.uploading.bar.message".localized(),
                        String(imageIndex + 1),
                        String(endIndex))
                    self?.imagesUploadingProgress(message)
                }
                self?.uploadTicketImages(with: identifier)
                }, failure: { [weak self] failure in
                    executeAfter(delay: 1) {
                        self?.uploadTicketImages(with: identifier)
                    }
                })
            }, failure: { [weak self] error in
                self?.imagesPathsToUpload!.removeFirst()
                self?.uploadTicketImages(with: identifier)
        })


    }

    func saveTicketToDraft() {
        ticket.createdDate = NSDate()
        ticket.replaceImagesSetWithArray(imagesPaths)
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    private func createTicket() -> Ticket? {
        guard let ticket =  Ticket.MR_createEntity(),
            category = TicketCategory.MR_createEntity(),
            type = TicketType.MR_createEntity(),
            state = TicketState.MR_createEntity() else {
                return nil
        }

        ticket.category = category
        ticket.ticketAddress = nil
        ticket.type = type
        ticket.state = state

        setRequiredData(for: ticket)

        if let user = User.currentUser() {
            ticket.user = user
        }

        guard let tickets =  Ticket.MR_findAllSortedBy("localIdentifier", ascending: false) as? [Ticket],
            localID = tickets.first?.localIdentifier else {
                ticket.localIdentifier = 0
                return ticket
        }
        ticket.localIdentifier = NSNumber(int: (localID.intValue + Constants.TicketConstants.IdIncrementer))

        return ticket
    }

    private func setRequiredData(for ticket: Ticket) {
        ticket.state?.identifier = Constants.TicketConstants.StateIdentifier
        ticket.state?.name = ""
        ticket.type?.identifier = Constants.TicketConstants.TypeIdentifier
        ticket.type?.name = ""
        ticket.ticketId = ""
    }

}

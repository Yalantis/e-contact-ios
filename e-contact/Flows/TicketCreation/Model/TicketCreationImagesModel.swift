//
//  TicketCreationImagesModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import DataSource

class TicketCreationImagesModel {

    var imagePathsChanges: ImagePathsChanges?
    var imageUploadCompletion: ImageUploadCompletion!
    private var photoUploadingIsCanceled = false
    private var collectionAdapter = CollectionViewAdapter<String>()
    private var ticket: Ticket?
    private(set) var imagesPaths = [String]() {
        didSet {
            collectionAdapter.dataSource = ArrayDataSource(objects: imagesPaths)

            collectionAdapter.reload()
        }
    }
    private var imagesPathsToUpload: [String]?
    private weak var locator: ServiceLocator!

    // MARK: - Life cycle

    init(locator: ServiceLocator, ticket: Ticket) {
        self.locator = locator
        self.ticket = ticket
    }

    // MARK: Public methods

    func update(imagesPaths: [String]) {
        self.imagesPaths = imagesPaths
    }

    // MARK: Private methods

    func setupCollectionViewAdapter(with collectionView: UICollectionView,
                                    didSelect closure: (String, NSIndexPath) -> Void) {
        collectionAdapter.collectionView = collectionView
        collectionAdapter.registerMapper(TableViewCollectionViewCellMapper())
        collectionAdapter.didSelect = closure
        if let ticketImagesPaths = ticket?.fetchCachedImagesPath() {
            imagesPaths.appendContentsOf(ticketImagesPaths)
        }
    }


}

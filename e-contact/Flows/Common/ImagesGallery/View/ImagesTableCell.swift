//
//  ImagesTableCell.swift
//  e-contact
//
//  Created by Illya on 3/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource


protocol ImagesTableCellDelegate {

    func imagesTableCellDidSelectObjectWith(diskPath: String, indexPath: NSIndexPath)

}


class ImagesTableCell: UITableViewCell {

    var delegate: ImagesTableCellDelegate?
    private(set) var imagesCollection: UICollectionView! {
        didSet {
            collectionAdapter.collectionView = imagesCollection
            collectionAdapter.registerMapper(TableViewCollectionViewCellMapper())
            collectionAdapter.didSelect = { [weak self] diskPath, indexPath in
                self?.delegate?.imagesTableCellDidSelectObjectWith(diskPath, indexPath: indexPath)
            }
        }
    }
    private var imagesPaths = [String]() {
        didSet {
            collectionAdapter.dataSource = ArrayDataSource(objects: imagesPaths)
            collectionAdapter.reload()
        }
    }
    private var collectionAdapter = CollectionViewAdapter<String>()

    // MARK - Mutators
    func setImagesPaths(imagesPaths: [String]) {
        self.imagesPaths = imagesPaths
    }

    func setImagesCollectionViewAndDelegate(imagesCollection: UICollectionView, delegate: ImagesTableCellDelegate) {
       self.imagesCollection = imagesCollection
       self.delegate = delegate
    }

}

//
//  ImageCollectionCell.swift
//  e-contact
//
//  Created by Illya on 3/28/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource
import Haneke
import QuartzCore

enum ActivityIndicatorViewStyle {

    case TableViewStyle, GalleryStyle

    func scaleFactor() -> CGFloat {
        switch self {
        case TableViewStyle:
            return 0.6
        case GalleryStyle:
            return 1

        }
    }

    func color() -> UIColor {
        switch self {
        case TableViewStyle:
            return UIColor.grayColor()
        case GalleryStyle:
            return UIColor.whiteColor()
        }

    }

}

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    private var isGalleryCell = false

    private var activityIndicatorViewStyle: ActivityIndicatorViewStyle!

    func setImageWithPath(path: String) {
        if path.hasPrefix("http://") {
            setImageFromNetworkPath(path)
        } else {
            setImageFromDiskPath(path)
        }
    }

    func setActivityIndicatorViewStyle(style: ActivityIndicatorViewStyle) {
            activityIndicatorView?.color = style.color()
            activityIndicatorView?.transform = CGAffineTransformMakeScale(style.scaleFactor(), style.scaleFactor())
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        if !isGalleryCell {
            imageView.hnk_cancelSetImage()
        }
    }

    // MARK: Private methods

    private func setImageFromNetworkPath(path: String) {
        guard let url = NSURL(string: path) else {
            return
        }
        layoutIfNeeded()

        isGalleryCell = true
        showActivityIndicatorView()
        imageView.hnk_setImageFromURL(url,
                                      format: imageView.hnk_format,
        failure: { [weak self] error in
            self?.hideActivityIndicatorView()
        },
        success: { [weak self] image in
            self?.hideActivityIndicatorView()
            self?.imageView.image = image
        })

    }

    private func setImageFromDiskPath(path: String) {
        imageView.hnk_setImageFromFile(path,
                                       placeholder: UIImage(named: "placeholder.png"),
                                       format: imageView.hnk_format,
                                       failure: nil,
                                       success: nil)
    }

    private func showActivityIndicatorView() {
        activityIndicatorView?.startAnimating()
    }

    private func hideActivityIndicatorView() {
        activityIndicatorView?.stopAnimating()
    }

}

class ImageCollectionCellMapper: ObjectMappable {

    var activityIndicatorViewStyle: ActivityIndicatorViewStyle {
        return ActivityIndicatorViewStyle.GalleryStyle
    }

    var cellIdentifier: String {
        return "imagesCollectionCell"
    }

    func supportsObject(object: Any) -> Bool {
        return true
    }

    func mapObject(object: Any, toCell cell: Any, atIndexPath: NSIndexPath) {
        guard let cell = cell as? ImageCollectionCell, path = object as? String else {
            return
        }
        cell.setActivityIndicatorViewStyle(activityIndicatorViewStyle)
        cell.setImageWithPath(path)
    }

}

class TableViewCollectionViewCellMapper: ImageCollectionCellMapper {

    override var activityIndicatorViewStyle: ActivityIndicatorViewStyle {
        return ActivityIndicatorViewStyle.TableViewStyle
    }

}

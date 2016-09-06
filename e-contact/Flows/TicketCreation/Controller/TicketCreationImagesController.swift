//
//  TicketCreationImagesController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/10/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource
import ImagePicker
import DeviceKit
import RSKImageCropper
import Photos

typealias ImagePickerPresenterAction = (controller: ImagePickerController, delegate: ImagePickerDelegate) -> Void
typealias ImageCropperPresenterAction = (delegate: RSKImageCropViewControllerDelegate,
                                         image: UIImage,
                                         cropMode: RSKImageCropMode) -> Void

protocol TicketCreationImagesDelegate: class {

    func ticketCreationImagesController(ticketCreationImagesController: TicketCreationImagesController,
                                        didSelect object: String,
                                        at IndexPath: NSIndexPath)

    func ticketCreationImagesController(ticketCreationImagesController: TicketCreationImagesController,
                                        didPickImage image: UIImage)

}

final class TicketCreationImagesController: UICollectionViewController, StoryboardInitable {

    static let storyboardName = "TicketCreation"
    var changes: Changes?
    var presentImagePicker: ImagePickerPresenterAction!
    var presentImgeCropper: ImageCropperPresenterAction!
    private var imagesPaths: [String] {
        return model.imagesPaths
    }
    private var collectionAdapter = CollectionViewAdapter<String>()
    private var model: TicketCreationImagesModel!
    private var imagePickerController: ImagePickerController?
    private var imageAssets: [PHAsset]? {
        didSet {
            iterateThroughImageAssetsWithCropping()
        }
    }
    private weak var delegate: TicketCreationImagesDelegate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModel()
    }

    func setDelegate(delegate: TicketCreationImagesDelegate) {
        self.delegate = delegate
    }
    func setModel(model: TicketCreationImagesModel) {
        self.model = model
    }

    func update(imagesPaths: [String]) {
        model.update(imagesPaths)
    }

    func startPickingImages() {
        imagePickerController = ImagePickerController()

        if Device().isOneOf(Constants.TicketCreation.ImagePickerDevicesToLimit) {
            imagePickerController?.imageLimit = Constants.TicketCreation.ImagePickerImageLimit
        }

        configureImagePickerAppearance()
        presentImagePicker(controller: imagePickerController!, delegate: self)
    }

    // MARK: Private methods

    private func setupModel() {
        model.setupCollectionViewAdapter(with: collectionView!) { [weak self] diskPath, indexPath in
            self?.delegate?.ticketCreationImagesController(self!, didSelect: diskPath, at: indexPath)
        }
    }

    private func configureImagePickerAppearance() {
        Configuration.backgroundColor = UIColor.applicationThemeColor()
        Configuration.mainColor = UIColor.applicationThemeColor()
        Configuration.cancelButtonTitle = "ticketCreation.alerts.cancel".localized()
        Configuration.doneButtonTitle = "ticketCreation.alerts.yes".localized()
        Configuration.settingsTitle = "ticketCreation.imagepicker.settings_button".localized()
        Configuration.noImagesColor = UIColor.applicationThemeColor()
        Configuration.noCameraColor = UIColor.applicationThemeColor()
    }

    private func iterateThroughImageAssetsWithCropping() {
        guard let imageAssets = imageAssets else {
            return
        }
        if !imageAssets.isEmpty {
            cropImageWithAsset(imageAssets.first!)
        }
    }

    private func cropImageWithAsset(asset: PHAsset) {
        asset.getAssetImageWithHandler() { [weak self] image in
            self?.presentImgeCropper(delegate: self!, image: image, cropMode: .Square)
        }
    }

}

// MARK: - ImagePickerDelegate methods

extension TicketCreationImagesController: ImagePickerDelegate {

    func doneButtonDidPress(images: [UIImage]) {
        imageAssets = imagePickerController!.stack.assets
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - RSKImageCropper Delegate

extension TicketCreationImagesController: RSKImageCropViewControllerDelegate {

    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        navigationController?.popViewControllerAnimated(false)
        imageAssets?.removeFirst()
    }

    func imageCropViewController(controller: RSKImageCropViewController,
                                 didCropImage croppedImage: UIImage,
                                              usingCropRect cropRect: CGRect,
                                                            rotationAngle: CGFloat) {

        navigationController?.popViewControllerAnimated(false)
        imageAssets?.removeFirst()
        changes?(true)
        delegate?.ticketCreationImagesController(self, didPickImage: croppedImage)
    }

}

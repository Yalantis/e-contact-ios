//
//  ImagesGalleryController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/22/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DataSource

final class ImagesGalleryController: UICollectionViewController, StoryboardInitable {

    static let storyboardName = "ImagesGallery"

    private var collectionAdapter = CollectionViewAdapter<String>()
    private var router: ImagesGalleryRouter!
    private var focusedIndex: NSIndexPath!
    private(set) var imagesPaths = [String]() {
        didSet {
            collectionAdapter.dataSource = ArrayDataSource(objects: imagesPaths)
        }
    }
    private var imagesPathsToUpload: [String]?
    private weak var locator: ServiceLocator!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewAdapter()
        if focusedIndex != nil {
            setupCollectionViewFlowLayout()
            setStatusBarHidden(true)
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        setStatusBarHidden(false)
    }

    func setStatusBarHidden(hidden: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(hidden, withAnimation: UIStatusBarAnimation.Slide)
    }


    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: ImagesGalleryRouter) {
        self.router = router
    }

    func setImagesPaths(imagesPaths: [String], focusedIndexPath: NSIndexPath, ticketTitle: String?) {
        self.focusedIndex = focusedIndexPath
        self.imagesPaths = imagesPaths
    }

    // MARK: - Actions

    @IBAction func closeButtonTouchUpInside(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

    // MARK: - Private methods

    private func setupCollectionViewAdapter() {
        collectionAdapter.collectionView = collectionView
        collectionAdapter.registerMapper(ImageCollectionCellMapper())
    }

    private func setupCollectionViewFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.itemSize = CGSize(
            width: collectionView!.bounds.size.width,
            height: collectionView!.bounds.size.width
        )
        collectionView!.pagingEnabled = true
        collectionView!.collectionViewLayout = flowLayout
        collectionView!.scrollToItemAtIndexPath(focusedIndex, atScrollPosition: .CenteredHorizontally, animated: true)
        collectionView!.reloadItemsAtIndexPaths([focusedIndex])
        collectionView!.collectionViewLayout.invalidateLayout()
    }

}

extension ImagesGalleryController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        var appearance = Appearance()
        appearance.navigationBar.shadowImage = nil
        appearance.navigationBar.backgroundColor = UIColor.blackColor()
        appearance.navigationBar.barTintColor = UIColor.blackColor()
        appearance.navigationBar.tintColor = UIColor.whiteColor()

        return appearance
    }

}

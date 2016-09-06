//
//  CategoryIconsService.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/19/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Haneke

final class CategoryIconsService {

    // MARK: - Values

    private unowned let apiClient: RestAPIClient
    private var currentIconsVersion: Int? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(Constants.IconsVersionKey) as? Int
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "iconsVersion")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    // MARK: - Init

    init(apiClient: RestAPIClient) {
        self.apiClient = apiClient
    }

    // MARK: - Methods

    func updateCategoryIcons() {
        let request = TicketCategoriesRequest()

        apiClient.executeRequest(request, success: { [unowned self] categoriesResponse in
            guard let categories = categoriesResponse.categories, version = categoriesResponse.version else {
                return
            }
            if let currentVersion = self.currentIconsVersion where currentVersion >= version {
                self.deleteCachedIcons(in: categories)
                self.currentIconsVersion = version
            }
            }, failure: nil)
    }

    // MARK: - Private Methods

    private func deleteCachedIcons(in categories: [TicketCategory]) {
        NSURLSession.sharedSession().resetWithCompletionHandler() {
            categories.flatMap { category in
                category.image?.imagePathForScale(Constants.Scale)?.absoluteString
                }.forEach { key in
                    Shared.imageCache.remove(key: key, formatName: Constants.CategoryIconsFormat.name)
            }
        }

    }

}

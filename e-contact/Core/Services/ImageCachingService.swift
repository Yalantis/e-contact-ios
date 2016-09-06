//
//  ImageCachingService.swift
//  e-contact
//
//  Created by Illya on 3/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import Haneke


final class ImageCachingService {

    let cache = Shared.dataCache
    let ticketCreationImagesFormat = Format<NSData>(name: "ticketCreationImages",
                                                    diskCapacity: Constants.TicketCreation.ImageCacheDiskCapacity,
                                                    transform: nil)

    init() {
        cache.addFormat(ticketCreationImagesFormat)
    }

    func saveAndResizeTicketCreationImage(image: UIImage, withCompletion completion: String -> ()) {
        let pictureData = reduceQuality(of: image)
        let key = NSUUID().UUIDString

        cache.set(value: pictureData,
                  key: key,
                  formatName: ticketCreationImagesFormat.name) { [weak self] data in
                    guard let this = self, baseUrl = NSURL(string: DiskCache.basePath()) else {
                        return
                    }

                    let url = baseUrl.URLByAppendingPathComponent("shared-data/\(this.ticketCreationImagesFormat.name)")
                    let cachedPath = DiskCache(path: url.absoluteString).pathForKey(key)
                    completion(cachedPath)
        }
    }

    func removeTicketCreationImage(at path: String) {
        if let key = path.componentsSeparatedByString(Constants.ImageCache.PathSeparator).last {
            cache.remove(key: key, formatName: ticketCreationImagesFormat.name)
        }
    }

    func loadTicketCreationImageData(from path: String, success: NSData -> (), failure: NSError? -> () ) {
        if let key = path.componentsSeparatedByString(Constants.ImageCache.PathSeparator).last {
            cache.fetch(key: key, formatName:  ticketCreationImagesFormat.name, failure: failure, success: success)
        }
    }

    private func reduceQuality(of image: UIImage) -> NSData {
        var imageQuality: CGFloat = Constants.TicketCreation.TopQuality
        var pictureData = UIImageJPEGRepresentation(image, imageQuality)

        while pictureData?.length > Constants.TicketCreation.ImageBytesSize {
            imageQuality = imageQuality * Constants.TicketCreation.QualityReducer
            pictureData = UIImageJPEGRepresentation(image, imageQuality)
        }

        return pictureData!
    }

}

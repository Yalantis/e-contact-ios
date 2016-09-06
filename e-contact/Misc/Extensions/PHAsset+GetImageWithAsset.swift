//
//  PHAsset+GetImageWithAsset.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Photos

extension PHAsset {

    func getAssetImageWithHandler(handler: UIImage -> Void) {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        option.synchronous = true
        manager.requestImageForAsset(self,
                                     targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                                     contentMode: .AspectFit,
        options: option) { result, _ in
            if let result = result {
                handler(result)
            }
        }
    }

}

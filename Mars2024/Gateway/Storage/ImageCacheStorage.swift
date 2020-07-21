//
//  ImageCacheStorage.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 20.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ImageCacheStorage: class {
    func add(image: UIImage, forUrl url: URL)
    func loadImage(forUrl url: URL) -> UIImage?
    
    var imageCache: AutoPurgingImageCache { get set }
}

class ImageCacheStorageImpl: ImageCacheStorage {
    
    var imageCache = AutoPurgingImageCache()
    
    func add(image: UIImage, forUrl url: URL) {
        let request = URLRequest(url: url)
        imageCache.add(image, for: request)
    }
    
    func loadImage(forUrl url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        return imageCache.image(for: request)
    }
}

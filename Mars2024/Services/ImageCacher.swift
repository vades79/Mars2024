//
//  ImageCacher.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 21.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class ImageCacher {
    
    static let shared = ImageCacher()
    
    private var cacher: ImageCacheStorage?
    
    private init(){
        cacher = Dependencies.shared.container.resolve(ImageCacheStorage.self)
    }
    
    func add(image: UIImage, forUrl url: URL) {
        cacher?.add(image: image, forUrl: url)
    }
    
    func loadImage(forUrl url: URL) -> UIImage? {
        return cacher?.loadImage(forUrl: url)
    }
}

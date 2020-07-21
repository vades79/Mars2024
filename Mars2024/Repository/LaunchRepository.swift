//
//  LaunchRepository.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RxSwift

protocol LaunchRepository: class {
    init(gateway: LaunchGateway)
    
    func launches(limit: Int, offset: Int) -> Observable<[Launch]>
    func loadImage(url: URL) -> Observable<UIImage>
    func loadImages(urls: [URL?]) -> Observable<[UIImage]>
}

class LaunchRepositoryImpl: LaunchRepository {
    
    let gateway: LaunchGateway
    
    required init(gateway: LaunchGateway) {
        self.gateway = gateway
    }
    
    func launches(limit: Int, offset: Int) -> Observable<[Launch]> {
        return gateway.launches(limit: limit, offset: offset)
    }
    
    func loadImage(url: URL) -> Observable<UIImage> {
        return gateway.loadImage(url: url).map { (image) in
            ImageCacher.shared.add(image: image, forUrl: url)
            return image
        }
    }
    
    func loadImages(urls: [URL?]) -> Observable<[UIImage]> {
        return Observable.create { (observer) -> Disposable in
            
            var tasks = [Observable<UIImage>]()
            var images = [UIImage]()
            
            for url in urls {
                guard let url = url else {
                    continue
                }
                
                if let image = ImageCacher.shared.loadImage(forUrl: url) {
                    images.append(image)
                } else {
                    tasks.append(self.loadImage(url: url))
                }
            }
            
            let downloadTasks = Observable
                .from(tasks)
                .merge()
                .subscribe(onNext: { (image) in
                    images.append(image)
                    if images.count == urls.count {
                        observer.onNext(images)
                        observer.onCompleted()
                    }
                }, onError: { (error) in
                    observer.onError(error)
                })
            
            return Disposables.create {
                downloadTasks.dispose()
            }
        }
    }
}

//
//  LaunchGateway.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Alamofire
import AlamofireImage

protocol LaunchGateway {
    init(router: LaunchRouter, sessionProvider: ApiSessionProvider)
    
    func launches(limit: Int, offset: Int) -> Observable<[Launch]>
    func loadImage(url: URL) -> Observable<UIImage>
}

class LaunchGatewayImpl: ApiProvider, LaunchGateway {
    
    let router: LaunchRouter
    
    required init(router: LaunchRouter, sessionProvider: ApiSessionProvider) {
        self.router = router
        super.init(sessionProvider: sessionProvider)
    }
    
    func launches(limit: Int, offset: Int) -> Observable<[Launch]> {
        let route = router.launches(limit: limit, offset: offset)
        return rxRequestJson(route: route).map({ (response) in
            guard case .success = response.result else {
                throw response.error!
            }
            guard let data = response.data else {
                throw ApiError.badResponse
            }
            do {
                var launchesArr = [Launch]()
                let jsonArray = try JSON(data: data).array
                
                guard let array = jsonArray else {
                    throw ApiError.badResponse
                }
                
                array.forEach { (json) in
                    guard let dictionaryObject = json.dictionaryObject else {
                        return
                    }
                    guard let dto = LaunchDto(JSON: dictionaryObject) else {
                        return
                    }
                    launchesArr.append(dto.toModel())
                }
                
                return launchesArr
            } catch {
                throw ApiError.badResponse
            }
        })
    }
    
    func loadImage(url: URL) -> Observable<UIImage> {
        return Observable.create { (observer) -> Disposable in
            Alamofire.request(url).responseImage { (response) in
                switch response.result {
                case .success(let image):
                    observer.onNext(image)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

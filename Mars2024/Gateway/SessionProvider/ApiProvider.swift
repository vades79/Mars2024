//
//  ApiProvider.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire

class ApiProvider {
    var sessionProvider: ApiSessionProvider?
    
    init(sessionProvider: ApiSessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func requestJson(route: ApiRoute) -> DataRequest? {
        let components = sessionProvider!.sessioned(route: route).components
        let request = Alamofire
                .request(
                components.url,
                method: components.method,
                parameters: components.data ,
                encoding: components.encoding,
                headers: components.headers)
        debugPrint(request)
        return request
    }
    
    func rxRequestJson( route: ApiRoute) -> Observable<DataResponse<Any>>{
        let components = sessionProvider!.sessioned(route: route).components
        
        return RxAlamofire
            .request(
                components.method,
                components.url,
                parameters: components.data,
                encoding: components.encoding,
                headers: components.headers)
            .map({ (request) -> DataRequest in
                debugPrint(request)
                return request
            })
            .responseJSON()
            .map { response in
                return response.validate()
        }
    }
}

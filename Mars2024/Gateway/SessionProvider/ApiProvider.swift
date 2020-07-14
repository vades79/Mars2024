//
//  ApiProvider.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON

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
            .debug()
            .responseJSON()
            .map { response in
                if case .success = response.result {
                    guard let code = response.response?.statusCode else {
                        throw ApiError.unknown
                    }
                    guard code >= 200, code < 300 else {
                        guard let data = response.data else {
                            throw ApiError.byHttpStatusCode(code)
                        }
                        do {
                            let json = try JSON(data: data)
                            guard let dict = json.dictionaryObject, let resp = BaseResponse(JSON: dict) else {
                                throw ApiError.byHttpStatusCode(code)
                            }
                            guard let errCode = resp.errorCode else {
                                throw ApiError.byHttpStatusCode(code)
                            }
                            throw ApiError.byCode(errCode)
                        } catch {
                            throw ApiError.byHttpStatusCode(code)
                        }
                    }
                    guard let _ = response.data else {
                        throw ApiError.badResponse
                    }
                }
                return response
                
        }
    }
}

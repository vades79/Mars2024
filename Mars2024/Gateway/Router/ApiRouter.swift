//
//  ApiRouter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol ApiRouter {
    var config: Config? { get set }
    var baseUrl: String { get }
    
    func route() -> ApiRoute
}

extension ApiRouter {
    
    var baseUrl: String {
        return config?.baseUrl ?? ""
    }
    
    func route() -> ApiRoute {
        let timeZone = "\(NSTimeZone.local.identifier),\(NSTimeZone.local.secondsFromGMT())"
        let appVersion = "ios:\(Bundle.main.releaseVersionNumber ?? "")"
        let defaultHeader = ["X-Time-Zone": timeZone,
                             "X-APP-VERSION" : appVersion]
        let components = ApiComponents(
            url: baseUrl,
            method: .get,
            encoding: URLEncoding.default,
            data: nil,
            headers: defaultHeader,
            multipertItems: nil
        )
        return ApiRoute(components: components, sessionType: .header)
    }
}

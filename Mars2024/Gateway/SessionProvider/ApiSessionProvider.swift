//
//  ApiSessionProvider.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol ApiSessionProvider {
    init(authProvider: AuthProvider)

    func sessioned(route: ApiRoute) -> ApiRoute
}

class ApiSessionProviderImpl: ApiSessionProvider {
    
    let authProvider: AuthProvider

    required init(authProvider: AuthProvider) {
        self.authProvider = authProvider
    }

    func sessioned(route: ApiRoute) -> ApiRoute {
        var sessionRoute = route
        switch route.sessionType {
        case .header:
            var headers = sessionRoute.components.headers ?? [:]
            headers["X-AUTH-TOKEN"] = authProvider.token ?? ""
            sessionRoute.components.headers = headers
        default:
            break
        }
        return sessionRoute
    }
}

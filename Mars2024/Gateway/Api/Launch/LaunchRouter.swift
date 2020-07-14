//
//  LaunchRouter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Alamofire

protocol LaunchRouter: ApiRouter {
    init(config: Config)
    
    func launches(limit: Int, offset: Int) -> ApiRoute
}

class LaunchRouterImpl: LaunchRouter {
    
    var config: Config?
    
    required init(config: Config) {
        self.config = config
    }
    
    func launches(limit: Int, offset: Int) -> ApiRoute {
        var route = self.route()
        var components = route.components
        components.url += "launches?limit=\(limit)&offset=\(offset)"
        components.method = .get
        components.encoding = URLEncoding.default
        route.setComponents(components)
        return route
    }
}

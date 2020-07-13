//
//  ApiRoute.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

struct ApiRoute {
    var components: ApiComponents
    var sessionType: ApiSessionType

    mutating func setComponents( _ components: ApiComponents) {
        self.components = components
    }

    mutating func setSessionType(_ type: ApiSessionType) {
        self.sessionType = type
    }
}

//
//  ApiSessionProvider.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol ApiSessionProvider {
    var authProvider: AuthProvider {get set}
    
    init(authProvider: AuthProvider)

    func sessioned(route: ApiRoute) -> ApiRoute
    
    func hasSession() -> Bool
}

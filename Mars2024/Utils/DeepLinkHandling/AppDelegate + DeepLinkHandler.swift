//
//  AppDelegate + DeepLinkHandler.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

extension AppDelegate: DeepLinkHandler {
    
    func open(deeplink: Deeplink, animated: Bool) -> DeepLinkHandling {
        let locked = DeepLinkProcessor.default.isLocked
        
        guard !locked else {
            return .rejected(deeplink, nil)
        }
        
        if let rootModule = self.rootModule {
            return .passedThrough(to: rootModule, deeplink)
        } else {
            return .rejected(deeplink, nil)
        }
    }
}

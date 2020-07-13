//
//  DeepLinkHandler.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol DeepLinkHandler: class {
    // stores the current state of deeplink handling
    var deeplinkHandling: DeepLinkHandling? { get set }
    // attempts to handle deeplink and returns next state
    func open(deeplink: Deeplink, animated: Bool) -> DeepLinkHandling
}

extension DeepLinkHandler {
    // Attempts to handle deeplink and updates its state,
    // should be always called instead of method that returns state
    func open(deeplink: Deeplink, animated: Bool) {
        let result = open(deeplink: deeplink, animated: animated)
        // you can track rejected or opened deeplinks here too
        deeplinkHandling = result
        
        if case let .passedThrough(handler, deeplink) = result {
            handler.open(deeplink: deeplink, animated: animated)
        }
    }
    
    // Call to complete deeplink handling if it was delayed
    func complete(deeplinkHandling: DeepLinkHandling?) {
        if case let .delayed(deeplink, animated)? = deeplinkHandling {
            open(deeplink: deeplink, animated: animated) as Void
            if case .delayed? = self.deeplinkHandling {
                return
            }
        }
    }
}

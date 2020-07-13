//
//  DeepLinkHandling.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

enum DeepLinkHandling: CustomStringConvertible {
    
    // deeplink successfully handled
    case opened(Deeplink)
    
    // deeplink was rejected because it can't be handeled, with optional log message
    case rejected(Deeplink, String?)

    // deeplink handling delayed because more data is needed
    case delayed(Deeplink, Bool)

    // deeplink was passed through to some other handler
    case passedThrough(to: DeepLinkHandler, Deeplink)
    
    var description: String {
        switch self {
            case .opened(let deeplink):
                return "Opened deeplink \(deeplink)"
            case .rejected(let deeplink, let reason):
                return "Rejected deeplink \(deeplink) for reason : \(reason ?? "unknown")"
            case .delayed(let deeplink, _):
                return "Delayed deeplink \(deeplink)"
            case .passedThrough(let handler, let deeplink):
                return "Passed through deeplink \(deeplink) to \(type(of: handler)))"
        }
    }
    
    
    
}

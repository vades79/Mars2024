//
//  TextStyles+Mars2024.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

fileprivate enum Mars2024: String {
    case medium = "Montserrat-Medium"
    case black = "Montserrat-Black"
}

extension TextStyle {
    
    static func title1(_ color: UIColor = .black) -> TextStyle {
        return .custom(Mars2024.medium.rawValue, size: 22, color: color)
    }
    
    static func title2(_ color: UIColor = .black) -> TextStyle {
        return .custom(Mars2024.medium.rawValue, size: 18, color: color)
    }
    
    static func title3(_ color: UIColor = .black) -> TextStyle {
        return .custom(Mars2024.medium.rawValue, size: 14, color: color)
    }
    
    static func buttonTitle(_ color: UIColor = .black) -> TextStyle {
        return .custom(Mars2024.medium.rawValue, size: 16.scaled, color: color)
    }
    
    static func buttonSubtitle(_ color: UIColor = .black) -> TextStyle {
        return .custom(Mars2024.medium.rawValue, size: 12.scaled, color: color)
    }
    
    static var errorTitle: TextStyle {
        return .custom(Mars2024.medium.rawValue, size: 12, color: .white)
    }
}

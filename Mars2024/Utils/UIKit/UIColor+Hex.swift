//
//  UIColor+Hex.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

extension UIColor {
    static func fromHex(_ hex: String) -> UIColor {
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        
        if (colorString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}

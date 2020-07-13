//
//  TextStyle.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

public enum FontType {
    case custom(name: String)
}

class TextStyle {
    
    fileprivate var font: UIFont?
    
    var fontType: FontType
    var preferredFontSize: CGFloat = 12
    var color: UIColor?
    var kern: Float?
    
    init(fontType: FontType, size: CGFloat, color: UIColor?, kern: Float? = nil) {
        self.fontType = fontType
        self.preferredFontSize = size
        self.color = color
        self.kern = kern
    }
    
    var currentFont: UIFont? {
        get {
            if let font = font {
                return font
            } else {
                switch fontType {
                case .custom(let name):
                    self.font = UIFont(name: name, size: self.preferredFontSize)
                }
                return self.font
            }
        }
    }
    
    var textAttributes: [NSAttributedString.Key: Any]{
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: self.currentFont!]
        if let color = self.color {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        return attributes
    }
    
    open class func custom(_ name: String, size: CGFloat, color: UIColor?) -> TextStyle {
        return style(.custom(name: name), size: size, color: color)
    }
    
    fileprivate class func style(_ fontType: FontType, size: CGFloat = 12, color: UIColor?) -> TextStyle {
        return TextStyle(fontType: fontType, size: size, color: color)
    }
}

//
//  String+AttributedText.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

extension String {
    /// Set style, alignment or interligne
    func attributedString(_ style: TextStyle, aligment: NSTextAlignment? = nil, linespacing: CGFloat? = nil) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: self.count)
        result.addAttributes(style.textAttributes, range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment ?? NSTextAlignment.left
        paragraphStyle.lineSpacing = linespacing ?? 0
        result.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
        return result
    }
}

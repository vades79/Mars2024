//
//  UILabelBuilder.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class UILabelBuilder {
    
    private var label: UILabel
    private var text = ""
    private var isAttributedString = false
    private var paragraphStyle = NSMutableParagraphStyle()
    
    init() {
        label = UILabel()
    }
    
    func set(text: String) -> UILabelBuilder {
        self.text = text
        return self
    }
    
    func set(style: TextStyle) -> UILabelBuilder {
        self.label.reapplyStyle(style)
        return self
    }
    
    func set(alignment: NSTextAlignment) -> UILabelBuilder {
        paragraphStyle.alignment = alignment
        self.label.textAlignment = alignment
        return self
    }
    
    func set(numberOfLines: Int) -> UILabelBuilder {
        self.label.numberOfLines = numberOfLines
        return self
    }
    
    func set(sizeToFit: Bool) -> UILabelBuilder {
        if sizeToFit {
            self.label.sizeToFit()
        }
        return self
    }
    
    func set(lineSpacing: Int) -> UILabelBuilder {
        isAttributedString = true
        paragraphStyle.lineSpacing = lineSpacing.vscaled
        return self
    }
    
    func build() -> UILabel {
        if isAttributedString {
            self.label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        } else {
            label.text = text
        }
        return self.label
    }
}

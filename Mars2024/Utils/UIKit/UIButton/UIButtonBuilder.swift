//
//  UIButtonBuilder.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class UIButtonBuilder {
    
    private var button: UIButton!
    
    init() {
        button = UIButton()
    }
    
    func set(title: String?, for state: UIControl.State) -> UIButtonBuilder {
        self.button.setTitle(title, for: state)
        return self
    }
    
    func set(_ image: UIImage?, for state: UIControl.State) -> UIButtonBuilder {
        self.button.setImage(image, for: state)
        return self
    }
    
    func set(cornerRadius: CGFloat) -> UIButtonBuilder{
        self.button.imageView?.layer.cornerRadius = cornerRadius
        self.button.layer.cornerRadius = cornerRadius
        return self
    }
    
    func set(borderWidth: CGFloat) -> UIButtonBuilder {
        self.button.layer.borderWidth = borderWidth
        return self
    }
    
    func set(borderColor: UIColor?) -> UIButtonBuilder {
        self.button.layer.borderColor = borderColor?.cgColor
        return self
    }
    
    func set(backgroundColor: UIColor) -> UIButtonBuilder {
        self.button.backgroundColor = backgroundColor
        return self
    }
    
    func set(style: TextStyle) -> UIButtonBuilder {
        self.button.reaplyStyle(style)
        return self
    }
    
    func set(imageEdgeInsets: UIEdgeInsets) -> UIButtonBuilder {
        self.button.imageEdgeInsets = imageEdgeInsets
        return self
    }
    
    func build() -> UIButton {
        return button
    }
}

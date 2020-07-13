//
//  UIButton+Style.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

extension UIButton {
    func reaplyStyle(_ style: TextStyle) {
        self.titleLabel?.font = style.currentFont
        self.titleLabel?.textColor = style.color
        self.setTitleColor(style.color, for: .normal)
    }
}

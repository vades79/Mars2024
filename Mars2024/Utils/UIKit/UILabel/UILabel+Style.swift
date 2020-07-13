//
//  UILabel+Style.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

extension UILabel {
    func reapplyStyle(_ style: TextStyle?) {
        self.backgroundColor = UIColor.clear;
        self.font = (style?.currentFont)!
        self.textColor = style?.color;
    }
}

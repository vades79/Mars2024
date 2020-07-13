//
//  UITextField+Style.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

extension UITextField {
    func reaplyStyle(_ style: TextStyle?) {
        guard let style = style else {
            self.font = nil
            self.textColor = UIColor.black
            return
        }
        self.font = style.currentFont
        self.textColor = style.color
    }
}

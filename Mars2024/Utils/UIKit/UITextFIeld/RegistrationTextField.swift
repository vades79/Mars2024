//
//  RegistrationTextField.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class RegistrationTextField: UITextField {
    var insetX: CGFloat = 6 {
       didSet {
         layoutIfNeeded()
       }
    }
    var insetY: CGFloat = 6 {
       didSet {
         layoutIfNeeded()
       }
    }
    
    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        layoutIfNeeded()
        return resigned
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
}

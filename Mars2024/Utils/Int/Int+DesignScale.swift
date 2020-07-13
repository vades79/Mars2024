//
//  Int+DesignScale.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class DesignSizes {
    static let width: CGFloat = 375.0
    static let height: CGFloat = 812.0
}

extension Int {
    public var scaled: CGFloat {
        get {
            let width = UIScreen.main.bounds.width
            let result = ceil(CGFloat(self) * width / DesignSizes.width)
            return CGFloat(result)
        }
    }
    
    public var vscaled: CGFloat {
        get {
            let height = UIScreen.main.bounds.height
            let result = ceil(CGFloat(self) * height / DesignSizes.height)
            return result
        }
    }
}

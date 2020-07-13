//
//  BaseNavigationController.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    var statusBarStyleOverride : UIStatusBarStyle? {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if let statusBarStyleOverride = statusBarStyleOverride {
                return statusBarStyleOverride
            }
            return super.preferredStatusBarStyle
        }
    }
}

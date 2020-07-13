//
//  UIViewController+Navigation.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 10.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

extension UIViewController {
    func navigatable() -> UINavigationController {
        return BaseNavigationController(rootViewController: self)
    }
    
    var hasPreviousController: Bool {
        guard let navigation = navigationController,
            navigation.viewControllers.count > 1,
            navigation.viewControllers.first != self
            else {
                return false
        }
        return true
    }
}

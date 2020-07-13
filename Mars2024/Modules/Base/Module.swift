//
//  Module.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

protocol Module: class {
    func navigationWrapped(_ viewController: UIViewController) -> UINavigationController
}

extension Module {
    func navigationWrapped(_ viewController: UIViewController) -> UINavigationController {
        return BaseNavigationController(rootViewController: viewController)
    }
}

//
//  ViewControllerModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

protocol ViewControllerModule: Module {
    var isLoaded: Bool { get }
    
    func entry() -> UIViewController
    func pushScreen(_ viewController: UIViewController, animated: Bool)
}

extension ViewControllerModule {
    
    var isLoaded: Bool {
        var isPresented = false
        var inNavigation = false
        let controller = entry()
        if let view = controller.view {
            isPresented = view.window != nil
        }
        inNavigation = controller.navigationController != nil
        return (isPresented || inNavigation)
    }
    
    func pushScreen(_ viewController: UIViewController, animated: Bool = true) {
        entry().navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func popScreen(animated: Bool = true) {
        entry().navigationController?.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        let view = entry()
        if let navigation = view.navigationController {
            if navigation.viewControllers.count > 1 {
                navigation.popViewController(animated: animated)
            }
        } else {
            view.dismiss(animated: animated)
        }
    }
}

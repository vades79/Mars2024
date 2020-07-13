//
//  RootPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol RootPresenter: class {
    var view: RootView? { get set }
    var module: Module? { get set }
    var router: RootRouter? { get set }
    
    func start()
}

class RootPresenterImpl: RootPresenter {
    var view: RootView?
    weak var module: Module?
    weak var router: RootRouter?
    
    func start() {
        router?.installLauncher()
    }
}

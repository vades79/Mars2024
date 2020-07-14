//
//  LaunchListModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

protocol LaunchListModuleDelegate: class {
    
}

class LaunchListModule: ViewControllerModule {
    weak var delegate : LaunchListModuleDelegate?
    
    let container: Container = Container(parent: Dependencies.shared.container)
    
    var launchDetailsModule: LaunchDetailsModule?
    
    init() {
        container.register(LaunchListView.self) { (r) in
            let result = LaunchListViewController()
            return result
            }.initCompleted { (r, view) in
                view.presenter = r.resolve(LaunchListPresenter.self)
            }.inObjectScope(.container)
        
        container.register(LaunchListPresenter.self) { (r) in
            LaunchListPresenterImpl()
            }.initCompleted { [weak self] (r, presenter) in
                presenter.view = r.resolve(LaunchListView.self)
                presenter.router = self
                presenter.module = self
                presenter.launchesRepository = r.resolve(LaunchRepository.self)
        }
    }
    
    func entry() -> UIViewController {
        let vc = container.resolve(LaunchListView.self) as! UIViewController
        return vc
    }
    
}

extension LaunchListModule: LaunchListRouter {
    func openLaunchDetails(launch: Launch) {
        launchDetailsModule = LaunchDetailsModule(launch: launch)
        pushScreen(launchDetailsModule!.entry(), animated: true)
    }
    
    func logout() {
        let link = LogoutDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }
}

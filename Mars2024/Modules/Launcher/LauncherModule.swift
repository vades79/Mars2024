//
//  LauncherModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

protocol LauncherModuleDelegate: class {
    
}

class LauncherModule: ViewControllerModule {
    weak var delegate: LauncherModuleDelegate?
    
    let container: Container = Container(parent: Dependencies.shared.container)
    
    init() {
        container.register(LauncherView.self) { (r) in
            let result = LauncherViewController()
            return result
            }.initCompleted { (r, view) in
                view.presenter = r.resolve(LauncherPresenter.self)
            }.inObjectScope(.container)
        
        container.register(LauncherPresenter.self) { (r) in
            LauncherPresenterImpl()
            }.initCompleted { [weak self] (r, presenter) in
                presenter.view = r.resolve(LauncherView.self)
                presenter.router = self
                presenter.module = self
                presenter.authProvider = r.resolve(AuthProvider.self)
                presenter.personRepository = r.resolve(PersonRepository.self)
        }
    }
    
    func entry() -> UIViewController {
        let vc = container.resolve(LauncherView.self) as! UIViewController
        return vc
    }
    
}

extension LauncherModule: LauncherRouter {
    func installSignUp() {
        let link = SignupDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }

    func installRegister() {
        let link = RegisterDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }

    func installMain() {
        let link = MainDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }
}

//
//  RegistrationModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

protocol RegistrationModuleDelegate : class {
    
}

class RegistrationModule : ViewControllerModule {
    weak var delegate : RegistrationModuleDelegate?
    
    let container: Container = Container(parent: Dependencies.shared.container)
    
    init() {
        container.register(RegistrationView.self) { (r) in
            let result = RegistrationViewController()
            return result
            }.initCompleted { (r, view) in
                view.presenter = r.resolve(RegistrationPresenter.self)
            }.inObjectScope(.container)
        
        container.register(RegistrationPresenter.self) { (r) in
            RegistrationPresenterImpl()
            }.initCompleted { [weak self] (r, presenter) in
                (presenter as! RegistrationPresenterImpl).attachView(r.resolve(RegistrationView.self)!)
                presenter.router = self
                presenter.module = self
                presenter.personRepository = r.resolve(PersonRepository.self)
                presenter.authProvider = r.resolve(AuthProvider.self)
        }
    }
    
    func entry() -> UIViewController {
        let vc = container.resolve(RegistrationView.self) as! UIViewController
        return vc
    }
    
}

extension RegistrationModule : RegistrationRouter {
    func openMain() {
        let link = MainDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }
    
    func logout() {
        let link = LogoutDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }
}

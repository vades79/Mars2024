//
//  SignUpModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

protocol SignUpModuleDelegate: class {
    
}

class SignUpModule: ViewControllerModule {
    weak var delegate : SignUpModuleDelegate?
    
    let container: Container = Container(parent: Dependencies.shared.container)
    
    // Modules
    
    
    init() {
        container.register(SignUpView.self) { (r) in
            let result = SignUpViewController()
            return result
            }.initCompleted { (r, view) in
                view.presenter = r.resolve(SignUpPresenter.self)
            }.inObjectScope(.container)
        
        container.register(SignUpPresenter.self) { (r) in
            SignUpPresenterImpl()
            }.initCompleted { [weak self] (r, presenter) in
                (presenter as! SignUpPresenterImpl).attachView(r.resolve(SignUpView.self)!)
                presenter.router = self
                presenter.module = self
                presenter.authProvider = r.resolve(AuthProvider.self)
                presenter.personRepository = r.resolve(PersonRepository.self)
        }
    }
    
    func entry() -> UIViewController {
        let vc = container.resolve(SignUpView.self) as! UIViewController
        return vc
    }
    
}

extension SignUpModule: SignUpRouter {
    func openEntry() {
        let link = EntryDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: false) as Void?
        }
    }
}

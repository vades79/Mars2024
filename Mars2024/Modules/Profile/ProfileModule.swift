//
//  ProfileModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

protocol ProfileModuleDelegate: class {
    
}

class ProfileModule: ViewControllerModule {
    weak var delegate : ProfileModuleDelegate?
    
    let container: Container = Container(parent: Dependencies.shared.container)
    
    init() {
        container.register(ProfileView.self) { (r) in
            ProfileViewController()
        }.initCompleted { (r, view) in
            view.presenter = r.resolve(ProfilePresenter.self)
        }.inObjectScope(.container)
        
        container.register(ProfilePresenter.self) { (r) in
            ProfilePresenterImpl()
        }.initCompleted { [weak self] (r, presenter) in
            presenter.view = r.resolve(ProfileView.self)
            presenter.router = self
            presenter.module = self
        }
    }
    
    func entry() -> UIViewController {
        let vc = container.resolve(ProfileView.self) as! UIViewController
        return vc
    }
    
}

extension ProfileModule: ProfileRouter {
    
}

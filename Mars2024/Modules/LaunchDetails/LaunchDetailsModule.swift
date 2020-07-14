//
//  LaunchDetailsModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

protocol LaunchDetailsModuleDelegate: class {
    
}

class LaunchDetailsModule: ViewControllerModule {
    weak var delegate : LaunchDetailsModuleDelegate?
    
    let container: Container = Container(parent: Dependencies.shared.container)
    
    init(launch: Launch) {
        container.register(LaunchDetailsView.self) { (r) in
            let result = LaunchDetailsViewController()
            return result
            }.initCompleted { (r, view) in
                view.presenter = r.resolve(LaunchDetailsPresenter.self)
            }.inObjectScope(.container)
        
        container.register(LaunchDetailsPresenter.self) { (r) in
            LaunchDetailsPresenterImpl(launch: launch)
            }.initCompleted { [weak self] (r, presenter) in
                (presenter as! LaunchDetailsPresenterImpl).attachView(r.resolve(LaunchDetailsView.self)!)
                presenter.router = self
                presenter.module = self
                presenter.launchesRepository = r.resolve(LaunchRepository.self)
        }
    }
    
    func entry() -> UIViewController {
        let vc = container.resolve(LaunchDetailsView.self) as! UIViewController
        return vc
    }
    
}

extension LaunchDetailsModule: LaunchDetailsRouter {
    
}

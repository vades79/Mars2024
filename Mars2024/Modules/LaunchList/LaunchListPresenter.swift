//
//  LaunchListPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol LaunchListPresenter: class {
    var router: LaunchListRouter? { get set }
    var view: LaunchListView? { get set }
    var module: LaunchListModule? { get set }
    
    func didLoad()
}

class LaunchListPresenterImpl: BaseNodeViewController {
    weak var module: LaunchListModule?
    weak var router: LaunchListRouter?
    
    override func didLoad() {
        super.didLoad()
        
    }
}

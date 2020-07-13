//
//  ProfilePresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol ProfilePresenter: class {
    var router: ProfileRouter? { get set }
    var view: ProfileView? { get set }
    var module: ProfileModule? { get set }
    
    func didLoad()
}

class ProfilePresenterImpl: BasePresenter<ProfileView>, ProfilePresenter {
    weak var module: ProfileModule?
    weak var router: ProfileRouter?
    
    override func didLoad() {
        super.didLoad()
        
    }
}

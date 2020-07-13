//
//  ProfileView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

protocol ProfileView: BaseView {
    var presenter: ProfilePresenter? { get set }
}

class ProfileViewController: BaseViewController {
    var presenter: ProfilePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    
}

extension ProfileViewController: ProfileView {
    
}

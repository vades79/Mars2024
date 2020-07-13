//
//  LaunchListView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

protocol LaunchListView: BaseView {
    var presenter: LaunchListPresenter? { get set }
}

class LaunchListViewController: BaseViewController {
    var presenter: LaunchListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    
}

extension LaunchListViewController: LaunchListView {
    
}

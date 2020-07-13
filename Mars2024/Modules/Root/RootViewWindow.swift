//
//  RootViewWindow.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class RootViewWindow: UIWindow {
    
    var presenter: RootPresenter?
    
    var isKey = false
    
    override func becomeKey() {
        super.becomeKey()
        self.backgroundColor = .white
        guard !isKey else {
            return
        }
        
        isKey = true
        start()
    }
}

extension RootViewWindow: RootView {
    func start() {
        presenter?.start()
    }
}

//
//  BasePresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class BasePresenter<View> {
    
    private var _view: AnyObject?
    
    var view: View? {
        get {
            return _view as? View
        }
        set {
            _view = newValue as AnyObject
        }
    }
    
    func attachView(_ view: View) {
        self._view = view as AnyObject
    }
    
    func detachView() {
        self.view = nil
    }
    
    func didLoad() {}
}

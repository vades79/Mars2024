//
//  BaseNodeViewController.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import MBProgressHUD

class BaseNodeViewController: ASViewController<ASDisplayNode> {
    
    var baseNode: ASDisplayNode!
    
    fileprivate var _isLoading = false
    
    init() {
        baseNode = ASDisplayNode()
        super.init(node: baseNode)
        setupSubnodes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubnodes() {
    /* В этом методе устанавливаются все свойства для nodes,
         чтобы init() оставался чистым */
    }
    
    func setupSubviews() {
    /* В этом методе устанавливаются все свойства для views,
         чтобы viewDidLoad() оставался чистым */
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            guard !_isLoading else { return }
            _isLoading = true
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .indeterminate
        } else {
            guard _isLoading else { return }
            _isLoading = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}


extension BaseNodeViewController: BaseView {
    func show(error: Error) {
        let title = R.string.localizable.errorAlertTitle()
        let message = error.localizedDescription
        let btnTitle = R.string.localizable.ok()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

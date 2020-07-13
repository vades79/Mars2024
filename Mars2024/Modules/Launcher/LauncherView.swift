//
//  LauncherView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

protocol LauncherView: BaseView {
    var presenter: LauncherPresenter? { get set }
    
    func initialError()
}

class LauncherViewController: BaseViewController {
    var presenter: LauncherPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }    
}

extension LauncherViewController : LauncherView {
    func initialError() {
        setLoading(false)

        let title = R.string.localizable.launcherAlertTitle()
        let message = R.string.localizable.launcherAlertInitialErrorMessage()
        let btnTitle = R.string.localizable.launcherAlertBtnTitleRepeat()

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (_) in
            self.setLoading(true)
            self.presenter?.reload()
        }))
        present(alert, animated: true, completion: nil)
    }
}


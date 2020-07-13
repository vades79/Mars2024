//
//  LauncherPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RxSwift

protocol LauncherPresenter: class {
    var router: LauncherRouter? { get set }
    var view: LauncherView? { get set }
    var module: LauncherModule? { get set }
    
    var authProvider: AuthProvider? { get set }
    var personRepository: PersonRepository? { get set }
    
    func didLoad()
    func reload()
}

class LauncherPresenterImpl: LauncherPresenter {
    weak var view: LauncherView?
    var module: LauncherModule?
    weak var router: LauncherRouter?
    
    var authProvider: AuthProvider?
    var personRepository: PersonRepository?
    
    var disposeBag = DisposeBag()
    
    func didLoad() {
        guard authProvider?.isAuth == true else {
            router?.installSignUp()
            return
        }
        _loadPerson()
    }
    
    func reload() {
        disposeBag = DisposeBag()
        _loadPerson()
    }
    
    private func _loadPerson() {
        personRepository?
            .person(refresh: true)
            .subscribe(
                onNext: { [weak self] (person) in
                    
                    if person.isMinFill {
                        self?.router?.installMain()
                        
                    } else {
                        self?.router?.installRegister()
                    }
                    
                }, onError: { [weak self] (error) in
                    
                    if error is ApiError {
                        let apiError = error as! ApiError
                        if apiError == .objectNotFound {
                            self?.router?.installRegister()
                            return
                        }
                    }
                    self?.view?.initialError()
            })
            .disposed(by: disposeBag)
    }
}

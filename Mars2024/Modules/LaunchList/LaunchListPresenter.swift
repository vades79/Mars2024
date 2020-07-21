//
//  LaunchListPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RxSwift

protocol LaunchListPresenter: class {
    var router: LaunchListRouter? { get set }
    var view: LaunchListView? { get set }
    var module: LaunchListModule? { get set }
    var launchesRepository: LaunchRepository? { get set }
    
    func didLoad()
    func logOut()
    func openLaunchDetails(launch: Launch)
    func loadPage(completion: (() -> Void)?)
    func reload(completion: (() -> Void)?)
}

class LaunchListPresenterImpl: LaunchListPresenter {
    weak var view: LaunchListView?
    weak var module: LaunchListModule?
    weak var router: LaunchListRouter?
    
    var launchesRepository: LaunchRepository?
    
    var isPageLoading = false
    var disposeBag = DisposeBag()
    
    var lastIndex: Int?
    
    func didLoad() {
    }
    
    func loadPage(completion: (() -> Void)?) {
        guard !isPageLoading else {
            completion?()
            return
        }
        _loadPage(reload: false, completion: completion)
    }
    
    func reload(completion: (() -> Void)?) {
        disposeBag = DisposeBag()
        lastIndex = nil
        _loadPage(reload: true, completion: completion)
    }
    
    private func _loadPage(reload: Bool, completion: (() -> Void)?) {
        isPageLoading = true
        launchesRepository?
            .launches(limit: 20, offset: lastIndex ?? 0)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] (launches) in
                    guard let `self` = self else {
                        return
                    }
                    self.isPageLoading = false
                    self.lastIndex = launches.last?.flightNumber
                    if reload {
                        self.view?.reload(launches: launches)
                    } else {
                        self.view?.append(launches: launches)
                    }
                    completion?()
                }, onError: { (error) in
                    print(error)
                    completion?()
                    self.isPageLoading = false
            }
        ).disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    func logOut() {
        router?.logout()
    }
    
    func openLaunchDetails(launch: Launch) {
        router?.openLaunchDetails(launch: launch)
    }
}

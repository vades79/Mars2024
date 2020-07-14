//
//  LaunchDetailsPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import RxSwift

protocol LaunchDetailsPresenter: class {
    var router: LaunchDetailsRouter? { get set }
    var view: LaunchDetailsView? { get set }
    var module: LaunchDetailsModule? { get set }
    var launchesRepository: LaunchRepository? { get set }
    
    init(launch: Launch)
    func didLoad()
}

class LaunchDetailsPresenterImpl: BasePresenter<LaunchDetailsView>, LaunchDetailsPresenter {
    weak var module: LaunchDetailsModule?
    weak var router: LaunchDetailsRouter?
    var launchesRepository: LaunchRepository?
    
    private let launch: Launch
    
    var disposeBag = DisposeBag()
    
    required init(launch: Launch) {
        self.launch = launch
    }
    
    override func didLoad() {
        super.didLoad()
        view?.fillData(launch: launch)
        loadHeaderImage(launch.missionPatch)
        loadImages(launch.images)
    }
    
    private func loadHeaderImage(_ url: URL?) {
        guard let url = url else {
            return
        }
        launchesRepository?
            .loadImage(url: url)
        .subscribe(
            onNext: { [weak self] (image) in
                self?.view?.addHeaderImage(image)
        })
        .disposed(by: disposeBag)
    }
    
    private func loadImages(_ urls: [URL?]?) {
        guard let urls = urls, !urls.isEmpty else {
            return
        }
        view?.enableIndicatorView(true)
        launchesRepository?
        .loadImages(urls: urls)
            .subscribe(onNext: { [weak self] (images) in
                self?.view?.addFlickrImage(images)
                self?.view?.enableIndicatorView(false)
            }, onError: { [weak self] (error) in
                print(error.localizedDescription)
                self?.view?.enableIndicatorView(false)
            })
        .disposed(by: disposeBag)
    }
}

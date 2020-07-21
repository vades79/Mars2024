//
//  LaunchDetailsView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

protocol LaunchDetailsView: BaseView {
    var presenter: LaunchDetailsPresenter? { get set }
    
    func fillData(launch: Launch)
    func addHeaderImage(_ image: UIImage)
    func addFlickrImage(_ images: [UIImage])
    func enableIndicatorView(_ bool: Bool)
    func enableHeaderIndicatorView(_ bool: Bool)
}

class LaunchDetailsViewController: BaseViewController {
    var presenter: LaunchDetailsPresenter?
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var headerImageView: UIImageView!
    var labelsStackView: UIStackView!
    var titleLabel: UILabel!
    var separatorView: UIView!
    var subtitleLabel: UILabel!
    var imagesView: ImagesView!
    
    var headerImageActivityIndicator: UIActivityIndicatorView!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    override func animationBlock() {
        var insets = scrollView.contentInset
        insets.bottom = keyboardHeight
        scrollView.contentInset = insets
        
        insets = scrollView.scrollIndicatorInsets
        insets.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets = insets
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        scrollView = UIScrollView()
        
        contentView = UIView()
        
        headerImageView = UIImageView()
        
        labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 8
        
        titleLabel = UILabelBuilder()
            .set(style: .title1())
            .build()
        
        separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        subtitleLabel = UILabelBuilder()
            .set(style: .title2())
            .set(numberOfLines: 0)
            .set(sizeToFit: true)
            .build()
        
        imagesView = ImagesView()
        imagesView.isHidden = true
        
        headerImageActivityIndicator = UIActivityIndicatorView()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = .lightGray
        
        // MARK: - Layout
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerImageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(separatorView)
        labelsStackView.addArrangedSubview(subtitleLabel)
        contentView.addSubview(imagesView)
        contentView.addSubview(headerImageActivityIndicator)
        contentView.addSubview(activityIndicator)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        headerImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-28.scaled * 2)
            make.size.equalTo(headerImageView.snp.width)
        }
        
        labelsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp.bottom).offset(24.vscaled)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-28.scaled * 2)
        }
        
        separatorView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(2)
        }
        
        imagesView.snp.makeConstraints { (make) in
            make.top.equalTo(labelsStackView.snp.bottom).offset(16.vscaled)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-28.scaled * 2)
            make.bottom.equalToSuperview().offset(-48.vscaled)
        }
        
        headerImageActivityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(headerImageView)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imagesView)
        }
    }
}

extension LaunchDetailsViewController: LaunchDetailsView {
    func fillData(launch: Launch) {
        titleLabel.text = launch.missionName
        if let date = launch.date {
            titleLabel.text! += " — \(date)"
        }
        
        if launch.details.isEmpty {
            subtitleLabel.text = R.string.localizable.launchDetailsEmptyDescription()
        } else {
            subtitleLabel.text = launch.details
        }
    }
    
    func addHeaderImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.headerImageView.image = image
            self.headerImageActivityIndicator.stopAnimating()
        }
    }
    
    func addFlickrImage(_ images: [UIImage]) {
        if imagesView.isHidden {
            imagesView.isHidden = false
        }
        DispatchQueue.main.async {
            self.imagesView.addImage(images)
        }
    }
    
    func enableHeaderIndicatorView(_ bool: Bool) {
        if bool {
            headerImageActivityIndicator.startAnimating()
        } else {
            headerImageActivityIndicator.stopAnimating()
        }
    }
    
    func enableIndicatorView(_ bool: Bool) {
        if bool {
            activityIndicator.startAnimating()
            imagesView.setPreviousHeight()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

//
//  ImagesView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 14.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class ImagesView: UIScrollView {
    
    var contentView: UIView!
    var imagesStackView: UIStackView!
    
    init() {
        super.init(frame: .zero)
        
        contentView = UIView()
        
        imagesStackView = UIStackView()
        imagesStackView.spacing = 1
        
        // MARK: - Layout
        addSubview(contentView)
        contentView.addSubview(imagesStackView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        imagesStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImage(_ images: [UIImage]) {
        images.forEach { (image) in
            let imageView = UIImageView(image: image)
            imagesStackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.size.equalTo(200)
            }
        }
    }
}

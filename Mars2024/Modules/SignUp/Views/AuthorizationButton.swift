//
//  AuthorizationButton.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class AuthorizationButton: UIButton {
    
    var customImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
//        layer.cornerRadius = self
        
        customImageView = UIImageView()
        customImageView.contentMode = .scaleAspectFit
        
        addSubview(customImageView)
        
        customImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().priority(.medium)
            make.right.equalTo(titleLabel!.snp.left).offset(-10)
            make.width.height.equalTo(24)
        }
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.reaplyStyle(.buttonTitle())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
    
    func setImage(_ image: UIImage?) {
        customImageView.image = image
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        customImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

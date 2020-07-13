//
//  TextFieldErrorView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class TextFieldErrorView: UIView {
    
    var textLabel: UILabel
    
    init(textError: String) {
        textLabel = UILabel()
        
        super.init(frame: .zero)
        backgroundColor = .errorLipstick
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.errorLipstick.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
        
        textLabel.reapplyStyle(.errorTitle)
        textLabel.text = textError
        textLabel.sizeToFit()
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
//            make.left.equalToSuperview().offset(42.scaled)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ChangeAvatarView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class ChangeAvatarView: UIControl {
    var titleLabel: UILabel!
    var photoView: UIImageView!
    var addIcon: UIImageView!
    
    var hasPhoto = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.text = R.string.localizable.registrationSetPhoto().uppercased()
        titleLabel.isUserInteractionEnabled = false
        titleLabel.reapplyStyle(.title3())
        
        photoView = UIImageView(image: R.image.astro())
        photoView.isUserInteractionEnabled = false
        photoView.layer.borderColor = UIColor.black.cgColor
        photoView.layer.borderWidth = 3
        photoView.layer.cornerRadius = (120.scaled / 2)
        photoView.clipsToBounds = true
        
        addIcon = UIImageView(image: R.image.icnAdd())
        addIcon.isUserInteractionEnabled = false
        
        addSubview(titleLabel)
        addSubview(photoView)
        addSubview(addIcon)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        photoView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(120.scaled)
        }
        
        addIcon.snp.makeConstraints { (make) in
            make.size.equalTo(40.scaled)
            make.right.bottom.equalTo(photoView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAvatarImage(_ image: UIImage?) {
        if image != nil {
            addIcon.isHidden = true
            hasPhoto = true
            titleLabel.text = R.string.localizable.registrationProfilePhoto().uppercased()
            photoView.image = image
        } else {
            addIcon.isHidden = false
            hasPhoto = false
            titleLabel.text = R.string.localizable.registrationSetPhoto().uppercased()
            photoView.image = R.image.astro()
        }
        
    }
}

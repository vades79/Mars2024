//
//  RegistrationField.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class RegistrationField: UIButton {
    
    var contentView: UIView!
    var descriptionLabel: UILabel!
    var textField: RegistrationTextField!
    var errorView: TextFieldErrorView!
    var isActiveError = false
    
    var updateField: ((String) -> Void)?
    
    init() {
        super.init(frame: .zero)
        
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        
        descriptionLabel = UILabel()
        descriptionLabel.reapplyStyle(.title3())
        descriptionLabel.isUserInteractionEnabled = false
        descriptionLabel.sizeToFit()
        
        textField = RegistrationTextField()
        textField.reaplyStyle(.title3())
        textField.autocorrectionType = .no
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
        
        // MARK: - Layout
        addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(textField)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview()
            make.height.greaterThanOrEqualTo(20.vscaled)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4.vscaled)
            make.bottom.left.right.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.height.equalTo(48.vscaled)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Error view
    
    func makeErrorView(error description: String) {
        
        guard !isActiveError else {
            return
        }
        
        isActiveError = true
        
        errorView = TextFieldErrorView(textError: description)
        errorView.isUserInteractionEnabled = false
        errorView.alpha = 0
        addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.edges.equalTo(textField)
        }
        
        UIViewPropertyAnimator(duration: 0.6, curve: .easeOut) {
            self.errorView.alpha = 1
        }.startAnimation()
    }
    
    func removeErrorView() {
        
        guard let _ = errorView else {
            return
        }
        
        isActiveError = false

        let removeAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            self.errorView.alpha = 0
        }
        
        removeAnimator.addCompletion { (_) in
            self.errorView.removeFromSuperview()
            self.errorView = nil
        }
        
        removeAnimator.startAnimation()
    }
    
    // MARK: - Helpers
    
    func fillTextField(_ text: String) {
        textField.text = text
    }
    
    func fillDescriptionText(_ text: String) {
        descriptionLabel.text = text
    }
    
    @objc
    fileprivate func onTap(_ sender: RegistrationField) {
        textField.becomeFirstResponder()
        if let _ = sender.errorView {
            sender.removeErrorView()
        }
    }
    
}


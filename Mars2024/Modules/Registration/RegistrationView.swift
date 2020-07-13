//
//  RegistrationView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol RegistrationView : BaseView {
    var presenter: RegistrationPresenter? { get set }
    
    func fillTextFieldsWith(person: Person)
    func validationErrors(_ errors: [PersonFieldType : RegistrationFieldError])
}

class RegistrationViewController : BaseViewController {
    var presenter : RegistrationPresenter?
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var changeAvatar: ChangeAvatarView!
    var fieldStackView: UIStackView!
    var submitButton: UIButton!
    var skipButton: UIButton!
    
    var imagePickerController: UIImagePickerController!
    var fields = [PersonFieldType: RegistrationField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
        configureView()
    }
    
    private func configureView() {
        navigationController?.navigationBar.isHidden = true
        
        shouldSubmitForKeyboardNotifications = true
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
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
        scrollView.keyboardDismissMode = .onDrag
        
        contentView = UIView()
        
        changeAvatar = ChangeAvatarView()
        changeAvatar.addTarget(self, action: #selector(pickPhotoActionSheet), for: .touchUpInside)
        
        changeAvatar.isSelected = false
        
        fieldStackView = UIStackView()
        fieldStackView.axis = .vertical
        
        for fieldType in PersonFieldType.allCases {
            let field = RegistrationField()
            field.textField.addTarget(self, action: #selector(textFieldChangeValue(_:)), for: .editingChanged)
            field.fillDescriptionText(fieldType.description)
            field.textField.tag = fieldType.tag
            field.textField.delegate = self
            
            fields[fieldType] = field
            fieldStackView.addArrangedSubview(field)
            
            switch fieldType {
            case .birthDate:
                let datePicker = makeDatePicker()
                field.textField.inputView = datePicker
                field.textField.inputAccessoryView = makeToolBar()
                
            default: break
            }
        }
        
        submitButton = UIButtonBuilder()
            .set(title: R.string.localizable.registrationSubmitBtnTitle(), for: .normal)
            .set(style: .buttonTitle(.white))
            .set(backgroundColor: .blue)
            .set(cornerRadius: 10)
            .build()
        submitButton.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        
        skipButton = UIButtonBuilder()
            .set(title: R.string.localizable.registrationSkipBtnTitle(), for: .normal)
            .set(style: .buttonSubtitle())
            .build()
        skipButton.addTarget(self, action: #selector(onSkip), for: .touchUpInside)
        
        // MARK: - Layout
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(changeAvatar)
        contentView.addSubview(fieldStackView)
        contentView.addSubview(submitButton)
        contentView.addSubview(skipButton)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        changeAvatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80.vscaled)
            make.centerX.equalToSuperview()
        }
        
        fieldStackView.snp.makeConstraints { (make) in
            make.top.equalTo(changeAvatar.snp.bottom).offset(24.vscaled)
            make.left.equalToSuperview().offset(48.scaled)
            make.right.equalToSuperview().offset(-48.scaled)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.top.equalTo(fieldStackView.snp.bottom).offset(48.vscaled)
            make.centerX.width.equalTo(fieldStackView)
            make.height.equalTo(65.vscaled)
        }
        
        skipButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(submitButton.snp.bottom).offset(14)
            make.bottom.equalToSuperview()
        }
        
    }
    
    // MARK: - Actions
    
    @objc private func onSubmit() {
        view.endEditing(true)
        presenter?.submit()
    }
    
    @objc private func onSkip() {
        view.endEditing(true)
        presenter?.skipRegistration()
    }
    
    @objc private func onDateChange(_ sender: UIDatePicker) {
        textFieldSet(sender.date.toString(), to: .birthDate)
        presenter?.update(value: sender.date.toString(), on: .birthDate)
    }
    
    @objc private func toolBarCloseButtonTap() {
        for (_, field) in fields {
            if field.textField.isFirstResponder {
                field.textField.resignFirstResponder()
            }
        }
    }
    
    @objc private func textFieldChangeValue(_ textField: UITextField) {
        guard let field = PersonFieldType.by(tag: textField.tag) else {
            return
        }
        
        let text = textField.text ?? ""
        presenter?.update(value: text, on: field)
    }
    
    // MARK: - Alerts
    
    @objc private func pickPhotoActionSheet() {
        let title = R.string.localizable.photoPickChoosePhotoSource()
        let photoLibratyTitle = R.string.localizable.photoPickPhotoLibrary()
        let cameraTitle = R.string.localizable.photoPickCamera()
        let cancelButtonTitle = R.string.localizable.photoPickCancel()
        let removeButtonTitle = R.string.localizable.photoPickRemove()
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        // Pick photo from library
        alert.addAction(UIAlertAction(title: photoLibratyTitle, style: .default, handler: { (_) in
            self.pickFromPhotoLibrary()
        }))
        // Pick photo from camera
        alert.addAction(UIAlertAction(title: cameraTitle, style: .default, handler: { (_) in
            self.pickFromCamera()
        }))
        // Remove photo from image button
        if changeAvatar.hasPhoto {
            alert.addAction(UIAlertAction(title: removeButtonTitle, style: .destructive, handler: { (_) in
                self.removePhoto()
            }))
        }
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    private func textFieldSet(_ value: String, to field: PersonFieldType) {
        fields[field]?.fillTextField(value)
    }
    
    private func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(onDateChange(_:)), for: .valueChanged)
        return datePicker
    }
    
    private func makeToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let title = R.string.localizable.registrationPickerBtnTitle()
        let closeButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toolBarCloseButtonTap))
        
        toolBar.setItems([closeButton], animated: false)
        return toolBar
    }
    
    // MARK: - Helpers: Photo
    
    private func pickFromPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }
    
    private func pickFromCamera() {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true)
    }
    
    private func setPhoto(_ photo: UIImage) {
        changeAvatar.setAvatarImage(photo)
        presenter?.setPhoto(photo)
    }
    
    private func removePhoto() {
        changeAvatar.setAvatarImage(nil)
        presenter?.setPhoto(nil)
    }
}

extension RegistrationViewController : RegistrationView {
    func validationErrors(_ errors: [PersonFieldType : RegistrationFieldError]) {
        for error in errors {
            if let field = fields[error.key] {
                field.makeErrorView(error: error.value.localizedDescription)
            }
        }
    }
    
    func fillTextFieldsWith(person: Person) {
        textFieldSet(person.givename, to: .givename)
        textFieldSet(person.familyname, to: .familyname)
        if let birthDate = person.birthDate {
            textFieldSet(birthDate.toString(), to: .birthDate)
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let type = PersonFieldType.by(tag: textField.tag) {
            if let nextType = type.next {
                fields[nextType]?.textField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}

// MARK: - UINavigationControllerDelegate

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[.editedImage] as? UIImage {
            setPhoto(photo)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

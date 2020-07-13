//
//  BaseViewController.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    var shouldSubmitForKeyboardNotifications = false
    var keyboardHeight: CGFloat = 0
    
    fileprivate var _isLoading = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        didSetupSubviews()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldSubmitForKeyboardNotifications {
            addObserver(selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardDidShowNotification)
            addObserver(selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver(name: UIResponder.keyboardWillShowNotification)
        removeObserver(name: UIResponder.keyboardWillHideNotification)
    }
    
    func didSetupSubviews() {
        
    }
    
    func setupSubviews() {
        
    }
    
    private func addObserver(selector: Selector, name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    
    private func removeObserver(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: name, object: object)
    }
    
    @objc private func keyboardWillAppear(_ notification: Notification) {
        guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber),
            let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)
        else {
            return
        }
        
        let frameInView = self.view.convert(frame, from: UIScreen.main.coordinateSpace)
        let intersection = self.view.bounds.intersection(frameInView)
        keyboardHeight = intersection.height
        
        let options = UIView.AnimationOptions(rawValue: curve.uintValue << 16)
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: options, animations: { [weak self] in
            self?.animationBlock()
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillDisappear(_ notification: Notification) {
        guard let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber),
            let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) else {
                return
        }
        
        keyboardHeight = 0
        
        let options = UIView.AnimationOptions(rawValue: curve.uintValue << 16)
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: options, animations: { [weak self] in
            self?.animationBlock()
            self?.view.layoutIfNeeded()
        })
    }
    
    // Метод для изменения insets у scrollView
    func animationBlock() {}
    
    func setLoading(_ loading: Bool) {
        if loading {
            guard !_isLoading else {
                return
            }
            _isLoading = true
            let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHud.mode = .indeterminate
        } else {
            guard _isLoading else {
                return
            }
            _isLoading = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func show(error: Error) {
        let title = R.string.localizable.errorAlertTitle()
        let message = error.localizedDescription
        let btnTitle = R.string.localizable.ok()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


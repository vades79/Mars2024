//
//  SignUpView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

protocol SignUpView: BaseView {
    var presenter: SignUpPresenter? { get set }
}

class SignUpViewController: BaseViewController {
    var presenter: SignUpPresenter?
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    var facebookButton: AuthorizationButton!
    var googleButton: AuthorizationButton!
    var appleButton: AuthorizationButton!
    
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
        configureView()
    }
    
    private func configureView() {
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        titleLabel = UILabelBuilder()
            .set(text: R.string.localizable.signUpTitle())
            .set(style: .title1())
            .set(numberOfLines: 0)
            .build()
        
        subtitleLabel = UILabelBuilder()
            .set(text: R.string.localizable.signUpSubtitle())
            .set(style: .title2())
            .set(numberOfLines: 0)
            .build()
        
        facebookButton = AuthorizationButton()
        facebookButton.addTarget(self, action: #selector(onFacebook), for: .touchUpInside)
        facebookButton.setTitle(R.string.localizable.signUpWithFacebook(), for: .normal)
        facebookButton.setImage(R.image.facebookLogo())
        
        googleButton = AuthorizationButton()
        googleButton.addTarget(self, action: #selector(onGoogle), for: .touchUpInside)
        googleButton.setTitle(R.string.localizable.signUpWithGoogle(), for: .normal)
        googleButton.setImage(R.image.googleLogo())
        
        if #available(iOS 13.0, *) {
            // Не будет работать
            // Для этого приложения не подключен вход на apple.developers
            appleButton = AuthorizationButton()
            appleButton.addTarget(self, action: #selector(onApple), for: .touchUpInside)
            appleButton.setTitle(R.string.localizable.signUpWithApple(), for: .normal)
            appleButton.setImage(R.image.appleLogo())
            appleButton.reaplyStyle(.buttonTitle(.lightGray))
            appleButton.backgroundColor = .gray
        }
        
        // MARK: - Layout
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(facebookButton)
        view.addSubview(googleButton)
        if #available(iOS 13.0, *) {
            view.addSubview(appleButton)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(88.vscaled).priority(.low)
            make.leading.equalToSuperview().offset(24)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.vscaled)
            make.leading.equalToSuperview().offset(24)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        facebookButton.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(72.vscaled)
        }
        
        googleButton.snp.makeConstraints { (make) in
            make.top.equalTo(facebookButton.snp.bottom).offset(24)
            make.leading.trailing.height.equalTo(facebookButton)
        }
        
        if #available(iOS 13.0, *) {
            appleButton.snp.makeConstraints { (make) in
                make.top.equalTo(googleButton.snp.bottom).offset(24)
                make.leading.trailing.height.equalTo(facebookButton)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func onFacebook() {
        let loginManager = LoginManager()
        loginManager.authType = .reauthorize
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { [weak self] (result, error) in
            if error == nil, let result = result {
                self?.presenter?.signUpFacebook(result)
            } else {
                print("Error login with facebook: \(error!)")
            }
        }
    }
    
    @objc private func onGoogle() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @available(iOS 13.0, *)
    @objc private func onApple() {
        let nonce = presenter?.randomNonceString()//randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = presenter?.sha256(nonce ?? "")

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension SignUpViewController: SignUpView {
    
}

// MARK: - GIDSignInDelegate

extension SignUpViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        presenter?.signUpGoogle(user)
    }
}

// MARK: - Apple delegate

@available(iOS 13.0, *)
extension SignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            presenter?.signUpApple(with: appleIDCredential, idTokenString, nonce)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

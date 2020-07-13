//
//  SignUpPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import RxSwift
import AuthenticationServices
import CryptoKit

protocol SignUpPresenter: class {
    var router: SignUpRouter? { get set }
    var view: SignUpView? { get set }
    var module: SignUpModule? { get set }
    var authProvider: AuthProvider? { get set }
    var personRepository: PersonRepository? { get set }
    
    func didLoad()
    func signUpFacebook(_ loginResult: LoginManagerLoginResult)
    func signUpGoogle(_ user: GIDGoogleUser)
    @available(iOS 13.0, *)
    func signUpApple(with credential: ASAuthorizationAppleIDCredential, _ idTokenString: String, _ currentNounce: String)
    func randomNonceString() -> String
    @available(iOS 13.0, *)
    func sha256(_ input: String) -> String
}

class SignUpPresenterImpl: BasePresenter<SignUpView>, SignUpPresenter {
    weak var module: SignUpModule?
    weak var router: SignUpRouter?
    
    var authProvider: AuthProvider?
    var personRepository: PersonRepository?
    
    var disposeBag = DisposeBag()
    
    override func didLoad() {
        super.didLoad()
    }
    
    func signUpFacebook(_ loginResult: LoginManagerLoginResult) {
        
        if !loginResult.isCancelled {
            guard let token = loginResult.token?.tokenString else {
                return
            }
            GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil, httpMethod: .get).start { [weak self] (_, result, error) in
                
                if error == nil {
                    let credential = FacebookAuthProvider.credential(withAccessToken: token)
                    self?.authWith(credential: credential)
                }
            }
        }
    }
    
    func signUpGoogle(_ user: GIDGoogleUser) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        authWith(credential: credential)
    }
    
    
    @available(iOS 13.0, *)
    func signUpApple(with appleIDCredential: ASAuthorizationAppleIDCredential, _ idTokenString: String, _ currentNounce: String) {
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: currentNounce)
        authWith(credential: credential)
    }
    
    // MARK: - Firebase
    private func authWith(credential: AuthCredential) {
        view?.setLoading(true)
        _firAuth(credential: credential) { [weak self] (id) in
            guard let `self` = self else {
                return
            }
            self.personRepository?
                .touchPerson()
                .subscribe(
                    onNext: { [weak self] (_) in
                        self?.view?.setLoading(false)
                        self?.router?.openEntry()
                },
                    onError: { [weak self] (error) in
                        self?.view?.setLoading(false)
                        self?.authProvider?.deauth()
                        self?.view?.show(error: error)
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func _firAuth(credential: AuthCredential, completion: @escaping ( (String) -> Void )) {
        Auth.auth().signIn(with: credential) { [weak self] (result, error) in
            guard error == nil else {
                self?.view?.setLoading(false)
                print(error!)
                self?.view?.show(error: error!)
                return
            }
            guard let id = result?.user.uid else {
                self?.view?.setLoading(false)
                self?.view?.show(error: ApiError.unknown)
                return
            }
            
            completion(id)
        }
    }
    
    // MARK: - Helpers
    
    func randomNonceString() -> String {
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = 32

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13.0, *)
    func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

//
//  RootModule.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

class RootModule: Module {

    let container: Container
    
    var deeplinkHandling: DeepLinkHandling?
    
    // MARK: - Modules
    
    var launcherModule: LauncherModule?
    var signUpModule: SignUpModule?
    var registrationModule: RegistrationModule?
    var launchListModule: LaunchListModule?
    
    init() {
        container = Container(parent: Dependencies.shared.container)

        container.register(RootView.self) { (r: Resolver) in
            let v = RootViewWindow()
            v.presenter = r.resolve(RootPresenter.self)
            return v
        }.inObjectScope(.container)

        container.register(RootPresenter.self) { (r: Resolver) in
            return RootPresenterImpl()
        }.initCompleted { (r: Resolver,s: RootPresenter) in
            s.view = r.resolve(RootView.self)
            s.module = self
            s.router = self
        }
    }
    
    func entry() -> UIWindow {
        return container.resolve(RootView.self) as! UIWindow
    }
    
    fileprivate func setRootController(_ controller: UIViewController, forWindow window: UIWindow) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    func logout() {
        let authProvider = container.resolve(AuthProvider.self)
        authProvider?.deauth()
        
        let link = EntryDeepLink(url: nil)!
        if let rootHandler = DeepLinkProcessor.default.handler {
            rootHandler.open(deeplink: link, animated: true) as Void?
        }
    }
}

// MARK: - RootRouter
extension RootModule: RootRouter {
    
    func installLauncher() {
        launchListModule = nil
        signUpModule = nil
        registrationModule = nil
        launcherModule = LauncherModule()
        setRootController(launcherModule!.entry(), forWindow: entry())
    }
    
    func installSignUp() {
        registrationModule = nil
        launcherModule = nil
        launchListModule = nil
        signUpModule = SignUpModule()
        setRootController(signUpModule!.entry().navigatable() , forWindow: entry())
    }
    
    func installRegister() {
        launcherModule = nil
        launchListModule = nil
        signUpModule = nil
        registrationModule = RegistrationModule()
        setRootController(registrationModule!.entry(), forWindow: entry())
    }
    
    func instalLaunchList() {
        launcherModule = nil
        signUpModule = nil
        registrationModule = nil
        launchListModule = LaunchListModule()
        setRootController(launchListModule!.entry(), forWindow: entry())
    }
}

// MARK: - DeepLinkHandler

extension RootModule: DeepLinkHandler {
    func open(deeplink: Deeplink, animated: Bool) -> DeepLinkHandling {
        switch deeplink {
            
        case is LogoutDeepLink:
            logout()
            return .opened(deeplink)
            
        case is EntryDeepLink:
            installLauncher()
            return .opened(deeplink)
            
        case is SignupDeepLink:
            installSignUp()
            return .opened(deeplink)
            
        case is RegisterDeepLink:
            installRegister()
            return .opened(deeplink)
            
        case is MainDeepLink:
            instalLaunchList()
            return .opened(deeplink)
            
        default:
            return .rejected(deeplink, nil)
        }
    }
}

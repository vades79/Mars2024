//
//  AppDelegate.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootModule: RootModule?
    var deeplinkHandling: DeepLinkHandling?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        
        // Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Google
        let clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.clientID = clientID
        
        // DeepLink
        DeepLinkProcessor.default.setHandler(self)
        
        rootModule = RootModule()
        window = rootModule?.entry()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var result = GIDSignIn.sharedInstance()?.handle(url) ?? false
        if !result {
            result = ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return result
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}


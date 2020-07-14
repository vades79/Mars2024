//
//  Dependencies.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Swinject

class Dependencies {
    
    static let shared = Dependencies()
    
    let container = Container()
    
    private init() {
        
        container.register(Config.self) { _ in
            ConfigImpl()
        }.inObjectScope(.container)
        
        container.register(AuthProvider.self) { (_) in
            return AuthProviderImpl()
        }
        
        container.register(ApiSessionProvider.self) { (r: Resolver) in
            ApiSessionProviderImpl(authProvider: r.resolve(AuthProvider.self)!)
        }.inObjectScope(.container)
        
        api()
        storage()
        repository()
    }
    
    private func api() {
        
        container.register(PersonGateway.self) { (_) in
            return PersonGatewayImpl()
        }
        
        container.register(LaunchRouter.self) { (r) in
            let config = r.resolve(Config.self)!
            
            return LaunchRouterImpl(config: config)
        }
        
        container.register(LaunchGateway.self) { (r) in
            let router = r.resolve(LaunchRouter.self)!
            let provider = r.resolve(ApiSessionProvider.self)!
            
            return LaunchGatewayImpl(router: router, sessionProvider: provider)
        }
        
    }
    
    private func storage() {
        container.register(JsonStorage.self) { (_) in
            return JsonStorage()
        }
        
        container.register(PersonStorage.self) { (_) in
            return PersonStorageImpl()
        }
    }
    
    private func repository() {
        container.register(PersonRepository.self) { (r) in
            let gateway = r.resolve(PersonGateway.self)!
            let authProvider = r.resolve(AuthProvider.self)!
            let personStorage = r.resolve(PersonStorage.self)!
            
            return PersonRepositoryImpl(gateway: gateway,
                                        authProvider: authProvider,
                                        personStorage: personStorage)
        }
        
        container.register(LaunchRepository.self) { (r) in
            let gateway = r.resolve(LaunchGateway.self)!
            
            return LaunchRepositoryImpl(gateway: gateway)
        }
    }
}

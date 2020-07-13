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
    }
}

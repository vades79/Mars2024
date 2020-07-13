//
//  AuthProvider.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 10.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Firebase

protocol AuthProvider {
    var isAuth: Bool { get }
    var token: String? { get }
    
    func deauth()
}

class AuthProviderImpl: AuthProvider {
    
    var isAuth: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var token: String? {
        get {
            Auth.auth().currentUser?.uid
        }
    }
    
    func deauth() {
        do {
            try? Auth.auth().signOut()
        } catch {
            print("Deauth is failed")
        }
    }
    
    
    
}

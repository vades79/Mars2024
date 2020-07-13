//
//  Deeplink.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol Deeplink {
    var url: URL { get }
    
    init?(url: URL?, dictionary: [String: Any]?)
}

struct RegisterDeepLink: Deeplink {
    let url: URL
    
    init?(url: URL?, dictionary: [String: Any]? = nil) {
        self.url = URL(string: "register")!
    }
}

struct SignupDeepLink: Deeplink {
    let url: URL
    
    init?(url: URL?, dictionary: [String: Any]? = nil) {
        self.url = URL(string: "signUp")!
    }
}

struct EntryDeepLink: Deeplink {
    let url: URL
    
    init?(url: URL?, dictionary: [String : Any]? = nil) {
        self.url = URL(string: "entry")!
    }
}

struct MainDeepLink: Deeplink {
    let url: URL
    
    init?(url: URL?, dictionary: [String: Any]? = nil) {
        self.url = URL(string: "main")!
    }
}

struct ProfileDeepLink: Deeplink {
    let url: URL
    var info: [String: Any]?
    
    init?(url: URL?, dictionary: [String: Any]? = nil) {
        self.url = url ?? URL(string: "profile")!
        self.info = dictionary
    }
}

struct LogoutDeepLink: Deeplink {
    let url: URL
    
    init?(url: URL?, dictionary: [String: Any]? = nil) {
        self.url = URL(string: "logout")!
    }
}

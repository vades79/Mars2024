//
//  Config.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol Config : class {
    var baseUrl: String { get }
}

class ConfigImpl: Config {
    private let apiBaseURL = "ApiBaseUrl"
    private let configDictionary: NSDictionary
    
    init(){
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            fatalError("Config must provided")
        }
        configDictionary = NSDictionary(contentsOfFile: path)!
    }
    
    var baseUrl: String {
        return configDictionary.object(forKey: apiBaseURL) as! String
    }
}

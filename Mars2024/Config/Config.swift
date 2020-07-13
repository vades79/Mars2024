//
//  Config.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class Config {
    private let apiBaseURL = "APIBaseUrl"
    private let apiLaunchesPath = 
    private let configDictionary: NSDictionary
    
    init(){
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            fatalError("Config must provided")
        }
        configDictionary = NSDictionary(contentsOfFile: path)!
    }
}

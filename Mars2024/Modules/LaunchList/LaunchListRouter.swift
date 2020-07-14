//
//  LaunchListRouter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol LaunchListRouter: class {
    func openLaunchDetails(launch: Launch)
    func logout()
}

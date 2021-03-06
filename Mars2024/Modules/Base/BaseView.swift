//
//  BaseView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol BaseView: class {
    func setLoading(_ loading: Bool)
    func show(error: Error)
}

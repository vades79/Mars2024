//
//  DateFormatterType.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

enum DateFormatterType: String {
    case `default` = "d MMMM yyyy"
    case stringTimestamp = "yyyy-MM-dd HH:mm:ss"
    case utc = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

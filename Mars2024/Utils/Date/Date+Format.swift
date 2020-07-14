//
//  Date+Format.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

extension Date {
    func toString(_ formatterType: DateFormatterType = .default) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterType.rawValue
        let dateString = formatter.string(from: self)
        return "\(dateString)"
    }
}

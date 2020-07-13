//
//  String+DateFormat.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

extension String {
    func toDate(formatterType: DateFormatterType = .default) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterType.rawValue
        guard let date = formatter.date(from: self) else { return nil }
        return date
    }
}

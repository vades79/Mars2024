//
//  RegistrationFieldError.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

enum RegistrationFieldError: Error {
    case required
    case notAlphabetic
    case lessThenCharacters(count: Int)
    case illegalAge
    
    var localizedDescription: String {
        switch self {
        case .required:
            return R.string.localizable.validationRequied()
        case .notAlphabetic:
            return R.string.localizable.validationAlphabetic()
        case .lessThenCharacters(count: let count):
            return R.string.localizable.validationTooSmall(count)
        case .illegalAge:
            return R.string.localizable.validationIllegalAge()
        }
    }
}

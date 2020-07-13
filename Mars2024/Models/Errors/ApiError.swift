//
//  ApiError.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case badResponse
    case badRequest
    case objectNotFound
    case unknown
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badResponse:
            return R.string.localizable.apiErrorBadResponse()
        case .badRequest:
            return R.string.localizable.apiErrorBadRequest()
        case .objectNotFound:
            return R.string.localizable.apiErrorObjectNotFound()
        case .unknown:
            return R.string.localizable.apiErrorUnknown()
        }
    }
}

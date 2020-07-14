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
    case unauthorized
    case server
    
    static func byCode(_ code: String) -> ApiError {
        switch code {
            default:
            return .unknown
        }
    }

    static func byHttpStatusCode(_ code: Int) -> ApiError {
        switch code {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 404:
            return .objectNotFound
        case 500:
            return .server
        default:
            return .unknown
        }
    }
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
        case .unauthorized:
            return R.string.localizable.apiErrorUserUnauthorized()
        case .server:
            return R.string.localizable.apiErrorServerError()
        }
    }
}

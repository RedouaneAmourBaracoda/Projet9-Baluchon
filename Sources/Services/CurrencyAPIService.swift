//
//  CurrencyApiService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

struct ExpectedCurrency: Codable {
    let data: [String: Float]
}

protocol CurrencyAPIService {

    init(urlSession: URLSession)

    func fetchCurrency(baseCurrency: String, convertToCurrency: String) async throws -> ExpectedCurrency
}

enum HTTPError: LocalizedError {
    case invalidURL
    case invalidRequest
    case invalidAuthenticationCredentials
    case invalidTrial
    case invalidEndpoint
    case validationError
    case exceededRequestsLimit
    case internalServorError

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        case .invalidAuthenticationCredentials:
            return NSLocalizedString("Invalid authentication credentials", comment: "")
        case .invalidTrial:
            return NSLocalizedString("You are not allowed to use this endpoint, please upgrade your plan", comment: "")
        case .invalidEndpoint:
            return NSLocalizedString("The requested endpoint does not exist", comment: "")
        case .validationError:
            return NSLocalizedString("Validation error, please check the list of validation errors", comment: "")
        case .exceededRequestsLimit:
            return NSLocalizedString("Invalid authentication credentials", comment: "")
        case .internalServorError:
            return NSLocalizedString("Invalid authentication credentials", comment: "")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        }
    }
}

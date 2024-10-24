//
//  OpenExchangeAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum OpenExchangeAPIError: LocalizedError, CaseIterable {
    case invalidURL
    case invalidBase
    case invalidAppId
    case accessRestricted
    case notFound
    case notAllowed
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .invalidBase:
            return NSLocalizedString("Client requested rates for an unsupported base currency", comment: "")
        case .invalidAppId:
            return NSLocalizedString("Client provided an invalid App ID", comment: "")
        case .accessRestricted:
            return NSLocalizedString(
                "Access restricted for repeated over-use (status: 429), or other reason given in ‘description’ (403)",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString("Client requested a non-existent resource/route", comment: "")

        case .notAllowed:
            return NSLocalizedString("Client doesn’t have permission to access requested route/feature", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        }
    }

    static func checkStatusCode(urlResponse: URLResponse) -> Result<Void, OpenExchangeAPIError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }

        let statusCode = httpURLResponse.statusCode

        switch statusCode {
        case 200: return .success(())

        case 400: return .failure(.invalidBase)

        case 401: return .failure(.invalidAppId)

        case 403: return .failure(.accessRestricted)

        case 404: return .failure(.notFound)

        case 429: return .failure(.notAllowed)

        default: return .failure(.invalidRequest)
        }
    }
}

extension String {
    static let currencyUndeterminedErrorDescription = "A non-determined error with currency services occured."
}

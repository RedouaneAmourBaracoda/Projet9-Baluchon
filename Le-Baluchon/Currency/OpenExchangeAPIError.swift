//
//  OpenExchangeAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum OpenExchangeAPIError: LocalizedError, CaseIterable {
    case invalidURL
    case invalid_base
    case invalid_app_id
    case access_restricted
    case not_found
    case not_allowed
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .invalid_base:
            return NSLocalizedString("Client requested rates for an unsupported base currency", comment: "")
        case .invalid_app_id:
            return NSLocalizedString("Client provided an invalid App ID", comment: "")
        case .access_restricted:
            return NSLocalizedString(" Access restricted for repeated over-use (status: 429), or other reason given in ‘description’ (403)", comment: "")
        case .not_found:
            return NSLocalizedString("Client requested a non-existent resource/route", comment: "")

        case .not_allowed:
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

            case 400: return .failure(.invalid_base)

            case 401: return .failure(.invalid_app_id)

            case 403: return .failure(.access_restricted)

            case 404: return .failure(.not_found)

            case 429: return .failure(.not_allowed)

            default: return .failure(.invalidRequest)
        }
    }
}

extension String {
    static let currencyUndeterminedErrorDescription = "A non-determined error with currency services occured. Please try again later."
}

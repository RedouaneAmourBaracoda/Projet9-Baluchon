//
//  OpenExchangeAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum OpenExchangeAPIError: CurrencyAPIError {
    case invalidURL
    case invalidBase
    case invalidAppId
    case accessRestricted
    case notFound
    case notAllowed
    case invalidRequest

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("currency.open-exchange-api.errors.invalid-url.description", comment: "")
        case .invalidBase:
            return NSLocalizedString("currency.open-exchange-api.errors.invalid-base.description", comment: "")
        case .invalidAppId:
            return NSLocalizedString("currency.open-exchange-api.errors.invalid-app-id.description", comment: "")
        case .accessRestricted:
            return NSLocalizedString(
                "currency.open-exchange-api.errors.restricted-access.description",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString("currency.open-exchange-api.errors.not-found.description", comment: "")
        case .notAllowed:
            return NSLocalizedString("currency.open-exchange-api.errors.not-allowed.description", comment: "")
        case .invalidRequest:
            return NSLocalizedString("currency.open-exchange-api.errors.invalid-request.description", comment: "")
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .invalidURL, .invalidBase, .invalidAppId, .notFound, .notAllowed, .invalidRequest:
            return NSLocalizedString(
                "currency.open-exchange-api.errors.invalid-request",
                comment: ""
            )
        case .accessRestricted:
            return NSLocalizedString(
                "currency.open-exchange-api.errors.access-restricted.user-friendly-description",
                comment: ""
            )
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
    static let currencyUndeterminedErrorDescription =
    NSLocalizedString(
        "currency.errors.undetermined.description",
        comment: ""
    )
}

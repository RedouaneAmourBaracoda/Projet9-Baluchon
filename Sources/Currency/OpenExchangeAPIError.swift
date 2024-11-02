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
            return Localizable.invalidURLDescription
        case .invalidBase:
            return Localizable.invalidBaseDescription
        case .invalidAppId:
            return Localizable.invalidAppIdDescription
        case .accessRestricted:
            return Localizable.accessRestrictedDescription
        case .notFound:
            return Localizable.notFoundDescription
        case .notAllowed:
            return Localizable.notAllowedDescription
        case .invalidRequest:
            return Localizable.invalidRequestDescription
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .invalidURL, .invalidBase, .invalidAppId, .notFound, .notAllowed, .invalidRequest:
            return Localizable.invalidRequestUserDescription
        case .accessRestricted:
            return Localizable.accessRestrictedUserDescription
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

private extension Localizable {
    static let invalidURLDescription = NSLocalizedString( "currency.open-exchange-api.errors.invalid-url.description",
        comment: ""
    )

    static let invalidBaseDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.invalid-base.description",
        comment: ""
    )

    static let invalidAppIdDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.invalid-app-id.description",
        comment: ""
    )

    static let accessRestrictedDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.restricted-access.description",
        comment: ""
    )
    static let notFoundDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.not-found.description",
        comment: ""
    )
    static let notAllowedDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.not-allowed.description",
        comment: ""
    )

    static let invalidRequestDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.invalid-request.description",
        comment: ""
    )

    static let invalidRequestUserDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.invalid-request",
        comment: ""
    )
    static let accessRestrictedUserDescription = NSLocalizedString(
        "currency.open-exchange-api.errors.access-restricted.user-friendly-description",
        comment: ""
    )
}

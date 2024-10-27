//
//  GoogleTranslationAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum GoogleTranslationAPIError: TranslationAPIError {
    case invalidURL
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case notAllowed
    case tooManyRequests
    case invalidRequest

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("translation.google-translation-api.errors.invalid-url.description", comment: "")
        case .badRequest:
            return NSLocalizedString("translation.google-translation-api.errors.bad-request.description", comment: "")
        case .unauthorized:
            return NSLocalizedString("translation.google-translation-api.errors.unauthorized.description", comment: "")
        case .paymentRequired:
            return NSLocalizedString(
                "translation.google-translation-api.errors.payment-required.description",
                comment: ""
            )
        case .forbidden:
            return NSLocalizedString(
                "translation.google-translation-api.errors.forbidden.description",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString("translation.google-translation-api.errors.not-found.description", comment: "")
        case .notAllowed:
            return NSLocalizedString(
                "translation.google-translation-api.errors.not-allowed.description",
                comment: ""
            )
        case .tooManyRequests:
            return NSLocalizedString(
                "translation.google-translation-api.errors.too-many-requests.description",
                comment: ""
            )
        case .invalidRequest:
            return NSLocalizedString(
                "translation.google-translation-api.errors.invalid-request.description",
                comment: ""
            )
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .invalidURL, .unauthorized, .invalidRequest, .notAllowed:
            return NSLocalizedString(
                "translation.google-translation-api.errors.invalid-request.user-friendly-description",
                comment: ""
            )
        case .badRequest, .notFound:
            return NSLocalizedString(
                "translation.google-translation-api.errors.bad-request.user-friendly-description",
                comment: ""
            )
        case .paymentRequired, .forbidden, .tooManyRequests:
            return NSLocalizedString(
                "translation.google-translation-api.errors.forbidden.user-friendly-description",
                comment: ""
            )
        }
    }

    static func checkStatusCode(urlResponse: URLResponse) -> Result<Void, GoogleTranslationAPIError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }

        let statusCode = httpURLResponse.statusCode

        switch statusCode {
        case 200: return .success(())

        case 400: return .failure(.badRequest)

        case 401: return .failure(.unauthorized)

        case 402: return .failure(.paymentRequired)

        case 403: return .failure(.forbidden)

        case 404: return .failure(.notFound)

        case 405: return .failure(.notAllowed)

        case 429: return .failure(.tooManyRequests)

        default: return .failure(.invalidRequest)
        }
    }
}

extension String {
    static let translationUndeterminedErrorDescription = NSLocalizedString(
        "translation.errors.undetermined.description",
        comment: ""
    )
}

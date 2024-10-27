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
            return NSLocalizedString("Invalid URL", comment: "")
        case .badRequest:
            return NSLocalizedString("The client provided invalid parameters for the request.", comment: "")
        case .unauthorized:
            return NSLocalizedString("The client provided invalid credentials or the session has expired.", comment: "")
        case .paymentRequired:
            return NSLocalizedString("The client has exceeded the limit of daily requests.", comment: "")
        case .forbidden:
            return NSLocalizedString(
                "The requested operation is not allowed due to restricted access or exceeded limit of requests.",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString("The client requested a non-existent resource/route", comment: "")
        case .notAllowed:
            return NSLocalizedString(
                "The client doesn’t have permission to access requested route/feature",
                comment: ""
            )
        case .tooManyRequests:
            return NSLocalizedString("The client has exceeded the limit of requests.", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .invalidURL, .unauthorized, .invalidRequest, .notAllowed:
            return NSLocalizedString(
                "There was an issue with translation services. Access is restricted or services are simply down.",
                comment: ""
            )
        case .badRequest, .notFound:
            return NSLocalizedString(
                "The city provided does not exist in data base or has invalid format.",
                comment: ""
            )
        case .paymentRequired, .forbidden, .tooManyRequests:
            return NSLocalizedString("The limit of requests to translation services has been exceeded.", comment: "")
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
    static let translationUndeterminedErrorDescription = "A non-determined error with translation services occured."
}

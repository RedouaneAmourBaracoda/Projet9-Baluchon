//
//  GoogleTranslationAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum GoogleTranslationAPIError: LocalizedError, CaseIterable {
    case invalidURL
    case bad_request
    case unauthorized
    case payment_required
    case forbidden
    case not_found
    case not_allowed
    case too_many_requests
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .bad_request:
            return NSLocalizedString("The client provided invalid query parameters for the request. It can be invalid fields, invalid values, or invalid api key.", comment: "")
        case .unauthorized:
            return NSLocalizedString("The client provided invalid credentials or the session has expired.", comment: "")
        case .payment_required:
            return NSLocalizedString("The client has exceeded the limit of daily requests and must upgrade the plan.", comment: "")
        case .forbidden:
            return NSLocalizedString("The requested operation is not allowed. It can be due to wrong access configuration, restricted access or exceeded limit of quotas for repeated over-use.", comment: "")
        case .not_found:
            return NSLocalizedString("The client requested a non-existent resource/route", comment: "")
        case .not_allowed:
            return NSLocalizedString("The http method for this request is not allowed. The client doesn’t have permission to access requested route/feature", comment: "")
        case .too_many_requests:
            return NSLocalizedString("The client has exceeded the limit of requests.", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        }
    }

    static func checkStatusCode(urlResponse: URLResponse) -> Result<Void, GoogleTranslationAPIError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }

        let statusCode = httpURLResponse.statusCode

        switch statusCode {
            case 200: return .success(())

            case 400: return .failure(.bad_request)

            case 401: return .failure(.unauthorized)

            case 402: return .failure(.payment_required)

            case 403: return .failure(.forbidden)

            case 404: return .failure(.not_found)

            case 405: return .failure(.not_allowed)

            case 429: return .failure(.too_many_requests)

            default: return .failure(.invalidRequest)
        }
    }
}

extension String {
    static let translationUndeterminedErrorDescription = "A non-determined error with translation services occured. Please try again later"
}

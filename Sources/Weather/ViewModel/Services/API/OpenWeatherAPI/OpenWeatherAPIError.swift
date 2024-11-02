//
//  OpenWeatherAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum OpenWeatherAPIError: WeatherAPIError {
    case invalidURL
    case badRequest
    case unauthorized
    case notFound
    case tooManyRequests
    case internalError
    case invalidRequest

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return Localizable.invalidURLDescription
        case .badRequest:
            return Localizable.badRequestDescription
        case .unauthorized:
            return Localizable.unauthorizedDescription
        case .notFound:
            return Localizable.notFoundDescription
        case .tooManyRequests:
            return Localizable.tooManyRequestsDescription
        case .internalError:
            return Localizable.internalErrorDescription
        case .invalidRequest:
            return Localizable.invalidRequestDescription
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .invalidURL, .unauthorized, .internalError, .invalidRequest:
            return Localizable.invalidRequestUserDescription
        case .badRequest, .notFound:
            return Localizable.badRequestUserDescription
        case .tooManyRequests:
            return Localizable.tooManyRequestsUserDescription
        }
    }

    static func checkStatusCode(urlResponse: URLResponse) -> Result<Void, OpenWeatherAPIError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }

        let statusCode = httpURLResponse.statusCode

        switch statusCode {
        case 200: return .success(())

        case 400: return .failure(.badRequest)

        case 401: return .failure(.unauthorized)

        case 404: return .failure(.notFound)

        case 429: return .failure(.tooManyRequests)

        case 500...599: return .failure(.internalError)

        default: return .failure(.invalidRequest)
        }
    }
}

private extension Localizable {
    static let invalidURLDescription = NSLocalizedString(
        "weather.open-weather-api.errors.invalid-url.description",
        comment: ""
    )

    static let badRequestDescription = NSLocalizedString(
        "weather.open-weather-api.errors.bad-request.description",
        comment: ""
    )

    static let unauthorizedDescription = NSLocalizedString(
        "weather.open-weather-api.errors.unauthorized.description",
        comment: ""
    )

    static let notFoundDescription = NSLocalizedString(
        "weather.open-weather-api.errors.not-found.description",
        comment: ""
    )

    static let tooManyRequestsDescription = NSLocalizedString(
        "weather.open-weather-api.errors.too-many-requests.description",
        comment: ""
    )

    static let internalErrorDescription = NSLocalizedString(
        "weather.open-weather-api.errors.internal-error.description",
        comment: ""
    )

    static let invalidRequestDescription = NSLocalizedString(
        "weather.open-weather-api.errors.invalid-request.description",
        comment: ""
    )

    static let invalidRequestUserDescription = NSLocalizedString(
        "weather.open-weather-api.errors.invalid-request.user-friendly-description",
        comment: ""
    )

    static let badRequestUserDescription = NSLocalizedString(
        "weather.open-weather-api.errors.bad-request.user-friendly-description",
        comment: ""
    )

    static let tooManyRequestsUserDescription = NSLocalizedString(
        "weather.open-weather-api.errors.too-many-requests.user-friendly-description",
        comment: ""
    )
}

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
            return NSLocalizedString("weather-open-weather-api.errors.invalid-url.description.", comment: "")
        case .badRequest:
            return NSLocalizedString(
                "weather-open-weather-api.errors.bad-request.description.",
                comment: ""
            )
        case .unauthorized:
            return NSLocalizedString(
                "weather-open-weather-api.errors.unauthorized.description",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString(
                "weather.open-weather-api.errors.not-found.description",
                comment: ""
            )
        case .tooManyRequests:
            return NSLocalizedString(
                "weather.open-weather-api.errors.too-many-requests.description",
                comment: ""
            )
        case .internalError:
            return NSLocalizedString("weather.open-weather-api.errors.internal-error.description", comment: "")
        case .invalidRequest:
            return NSLocalizedString("weather.open-weather-api.errors.invalid-request.description", comment: "")
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .invalidURL, .unauthorized, .internalError, .invalidRequest:
            return NSLocalizedString(
                "weather.open-weather-api.errors.invalid-request.user-friendly-description",
                comment: ""
            )
        case .badRequest, .notFound:
            return NSLocalizedString(
                "weather.open-weather-api.errors.bad-request.user-friendly-description",
                comment: ""
            )
        case .tooManyRequests:
            return NSLocalizedString(
                "weather.open-weather-api.errors.too-many-requests.user-friendly-description",
                comment: ""
            )
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

extension String {
    static let weatherUndeterminedErrorDescription = NSLocalizedString(
        "weather.errors.undetermined.description",
        comment: ""
    )
}

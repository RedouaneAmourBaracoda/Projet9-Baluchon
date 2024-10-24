//
//  OpenWeatherAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum OpenWeatherAPIError: LocalizedError, CaseIterable {
    case invalidURL
    case badRequest
    case unauthorized
    case notFound
    case tooManyRequests
    case internalError
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .badRequest:
            return NSLocalizedString(
                "Missing parameters in the request or some have incorrect format or values out of allowed range.",
                comment: ""
            )
        case .unauthorized:
            return NSLocalizedString(
                "API token not providen in the request or if provided does not grant access to this API.",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString(
                "Data with requested parameters (lat, lon, date etc) does not exist in service database",
                comment: ""
            )
        case .tooManyRequests:
            return NSLocalizedString(
                "Quota of requests was exceeded. Retry request later or after extending your key quota.",
                comment: ""
            )
        case .internalError:
            return NSLocalizedString("Unexpected Error due to internal issues.", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
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

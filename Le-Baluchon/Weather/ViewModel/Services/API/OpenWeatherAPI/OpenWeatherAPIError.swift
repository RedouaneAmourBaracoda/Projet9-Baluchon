//
//  OpenWeatherAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

enum OpenWeatherAPIError: LocalizedError, CaseIterable {
    case invalidURL
    case bad_request
    case unauthorized
    case not_found
    case too_many_requests
    case internalError
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .bad_request:
            return NSLocalizedString("Some mandatory parameters in the request are missing or some of request parameters have incorrect format or values out of allowed range.", comment: "")
        case .unauthorized:
            return NSLocalizedString("API token did not providen in the request or in case API token provided in the request does not grant access to this API.", comment: "")
        case .not_found:
            return NSLocalizedString("Data with requested parameters (lat, lon, date etc) does not exist in service database", comment: "")
        case .too_many_requests:
            return NSLocalizedString("Quota of requests to this API was exceeded. You may retry request after some time or after extending your key quota.", comment: "")
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

            case 400: return .failure(.bad_request)

            case 401: return .failure(.unauthorized)

            case 404: return .failure(.not_found)

            case 429: return .failure(.too_many_requests)

            case 500...599: return .failure(.internalError)

            default: return .failure(.invalidRequest)
        }
    }
}

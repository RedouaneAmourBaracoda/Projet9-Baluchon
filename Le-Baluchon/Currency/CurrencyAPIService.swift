//
//  CurrencyApiService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

struct ExpectedCurrency: Codable {
    let data: [String: Double]
}

final class CurrencyApiService {
    private let apiKey = "apikey=fca_live_R11DyeLSP60BGObpEoPh1Clh8U7tlGQg3EG2cfAA"
    private let urlString: String = "https://api.freecurrencyapi.com/v1/latest?"

    // Injection de dépendance.
    private var session: URLSession = .shared
    init(session: URLSession) {
        self.session = session
    }
    
    // Singleton pattern.
    static let shared: CurrencyApiService = .init()
    private init() {}

    func fetchCurrency(baseCurrency: String, convertToCurrency: String) async throws -> ExpectedCurrency {
        let parameters = "&currencies=" + convertToCurrency + "&base_currency=" + baseCurrency
        guard let url = URL(string: urlString + apiKey + parameters) else { throw HTTPError.invalidURL }
        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        let result = checkStatusCode(urlResponse: response)

        switch result {
        case .success():
            return try JSONDecoder().decode(ExpectedCurrency.self, from: data)
        case let .failure(failure):
            throw failure
        }
    }

    private func checkStatusCode(urlResponse: URLResponse) -> Result<Void, HTTPError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }
        let statusCode = httpURLResponse.statusCode
        switch statusCode {
            case 200 : return .success(())

            case 401: return .failure(.invalidAuthenticationCredentials)

            case 403: return .failure(.invalidTrial)

            case 404: return .failure(.invalidEndpoint)

            case 422: return .failure(.validationError)

            case 429: return .failure(.exceededRequestsLimit)

            case 500: return .failure(.internalServorError)

            default: return .failure(.invalidRequest)
        }
    }
}

enum HTTPError: LocalizedError {
    case invalidURL
    case invalidRequest
    case invalidAuthenticationCredentials
    case invalidTrial
    case invalidEndpoint
    case validationError
    case exceededRequestsLimit
    case internalServorError

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        case .invalidAuthenticationCredentials:
            return NSLocalizedString("Invalid authentication credentials", comment: "")
        case .invalidTrial:
            return NSLocalizedString("You are not allowed to use this endpoint, please upgrade your plan", comment: "")
        case .invalidEndpoint:
            return NSLocalizedString("The requested endpoint does not exist", comment: "")
        case .validationError:
            return NSLocalizedString("Validation error, please check the list of validation errors", comment: "")
        case .exceededRequestsLimit:
            return NSLocalizedString("Invalid authentication credentials", comment: "")
        case .internalServorError:
            return NSLocalizedString("Invalid authentication credentials", comment: "")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        }
    }
}


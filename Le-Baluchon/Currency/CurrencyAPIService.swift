//
//  CurrencyApiService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

protocol CurrencyAPIService {
    func fetchCurrency() async throws -> ExpectedRates
}

final class MockCurrencyAPIService: CurrencyAPIService {

    var ratesToReturn: ExpectedRates?

    var error: Error?

    var fetchCurrencyCallsCounter: Int = 0

    func fetchCurrency() async throws -> ExpectedRates {
        fetchCurrencyCallsCounter += 1

        guard let error else { return ratesToReturn ?? .init(rates: [:]) }

        throw error
    }
}

final class RealCurrencyApiService: CurrencyAPIService {

    var urlString: String = APIInfos.endpointString

    // Injection de dépendance.
    private var session: URLSession = .shared

    init(session: URLSession) {
        self.session = session
    }
    
    // Singleton pattern.
    static let shared: RealCurrencyApiService = .init()

    private init() {}

    func fetchCurrency() async throws -> ExpectedRates {
        guard let url = URL(string: urlString) else { throw HTTPError.invalidURL }
        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        let result = checkStatusCode(urlResponse: response)

        switch result {
        case .success():
            return try JSONDecoder().decode(ExpectedRates.self, from: data)
        case let .failure(failure):
            throw failure
        }
    }

    private func checkStatusCode(urlResponse: URLResponse) -> Result<Void, HTTPError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }

        let statusCode = httpURLResponse.statusCode

        switch statusCode {
            case 200 : return .success(())

            case 400: return .failure(.invalid_base)

            case 401: return .failure(.invalid_app_id)

            case 403: return .failure(.access_restricted)

            case 404: return .failure(.not_found)

            case 429: return .failure(.not_allowed)

            default: return .failure(.invalidRequest)
        }
    }
}

struct ExpectedRates: Codable {
    let rates: [String: Double]
}

enum HTTPError: LocalizedError, CaseIterable {
    case invalidURL
    case invalid_base
    case invalid_app_id
    case access_restricted
    case not_found
    case not_allowed
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .invalid_base:
            return NSLocalizedString("Client requested rates for an unsupported base currency", comment: "")
        case .invalid_app_id:
            return NSLocalizedString("Client provided an invalid App ID", comment: "")
        case .access_restricted:
            return NSLocalizedString(" Access restricted for repeated over-use (status: 429), or other reason given in ‘description’ (403)", comment: "")
        case .not_found:
            return NSLocalizedString("Client requested a non-existent resource/route", comment: "")

        case .not_allowed:
            return NSLocalizedString("Client doesn’t have permission to access requested route/feature", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        }
    }
}

enum APIInfos {

    static let urlString: String = "https://openexchangerates.org/api/latest.json?"

    static let appID = "b9fcd43d720d4b7a85a924cd61d64f8a"

    static var endpointString = urlString + "app_id=" + appID
}

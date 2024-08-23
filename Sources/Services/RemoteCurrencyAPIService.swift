//
//  RemoteCurrencyAPIService.swift
//  Le-BaluchonTests
//
//  Created by Damien Rivet on 23/08/2024.
//

import Foundation

final class RemoteCurrencyAPIService: CurrencyAPIService {

    // MARK: - Constants

    private let apiKey = "apikey=fca_live_R11DyeLSP60BGObpEoPh1Clh8U7tlGQg3EG2cfAA"
    private let urlString: String = "https://api.freecurrencyapi.com/v1/latest?"

    // MARK: - Properties

    // Injection de dépendance.
    private var urlSession: URLSession

    // MARK: - Initialisation

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - Functions

    func fetchCurrency(baseCurrency: String, convertToCurrency: String) async throws -> ExpectedCurrency {
        let parameters = "&currencies=" + convertToCurrency + "&base_currency=" + baseCurrency

        guard let url = URL(string: urlString + apiKey + parameters) else { throw HTTPError.invalidURL }

        let request = URLRequest(url: url)

        let (data, response) = try await urlSession.data(for: request)

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

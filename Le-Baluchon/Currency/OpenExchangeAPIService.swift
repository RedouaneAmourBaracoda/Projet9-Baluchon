//
//  CurrencyApiService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

struct OpenExchangeAPIService: CurrencyAPIService {

    // MARK: - API infos.

    private enum APIInfos {

        static let ressource = "https://openexchangerates.org/api/latest.json?"

        static let appID = "b9fcd43d720d4b7a85a924cd61d64f8a"

        static let url = ressource + "app_id=" + appID
    }

    // MARK: - Properties.

    var urlString = APIInfos.url

    private var session: URLSession

    // MARK: - Dependency injection.

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchCurrency() async throws -> [String: Double] {
        guard let url = URL(string: urlString) else { throw OpenExchangeAPIError.invalidURL }

        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        let result = OpenExchangeAPIError.checkStatusCode(urlResponse: response)

        switch result {

        case .success:

            return try JSONDecoder()
                .decode(OpenExchangeAPIResponse.self, from: data)
                .rates

        case let .failure(failure):

            throw failure
        }
    }
}

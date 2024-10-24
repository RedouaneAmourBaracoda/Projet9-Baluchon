//
//  TranslationAPIService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

struct GoogleTranslationAPIService: TranslationAPIServiceType {

    // MARK: - API infos.

    private enum APIInfos {

        static let ressource = "https://translation.googleapis.com/language/translate/v2?"

        static let key = "AIzaSyD2PKuGzRMcreo6MJu9c7SvTF5PsPR1fso"

        static let url = ressource + "key=" + key
    }

    // MARK: - Properties.

    var urlString = APIInfos.url

    private var session: URLSession

    // MARK: - Dependency injection.

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchTranslation(text: String, source: String, target: String, format: String) async throws -> String {

        guard let url = URL(string: urlString) else { throw GoogleTranslationAPIError.invalidURL }

        var request = URLRequest(url: url)

        // HTTP Method.
        request.httpMethod = "POST"

        // HTTP Headers.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // HTTP Body.
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "q": text,
            "source": source,
            "target": target,
            "format": format
        ])

        let (data, response) = try await session.data(for: request)

        let result = GoogleTranslationAPIError.checkStatusCode(urlResponse: response)

        switch result {

        case .success:

            return try JSONDecoder()
                .decode(GoogleTranslationAPIResponse.self, from: data)
                .toString

        case let .failure(failure):

            throw failure
        }
    }
}

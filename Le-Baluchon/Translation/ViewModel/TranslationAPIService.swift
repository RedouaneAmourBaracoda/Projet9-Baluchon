//
//  TranslationAPIService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

protocol TranslationAPIService {
    func fetchTranslation(q: String, source: String, target: String, format: String ) async throws -> GoogleAPIResponse
}

//final class MockTranslationAPIService: TranslationAPIService {
//
//    var translationToReturn: GoogleAPIResponse?
//
//    var error: Error?
//
//    var fetchTranslationCallsCounter: Int = 0
//
//    func fetchTranslation(q: String, source: String, target: String, format: String ) async throws -> GoogleAPIResponse {
//        fetchTranslationCallsCounter += 1
//
//        guard let error else { return translationToReturn ?? .init(translations: [:]) }
//
//        throw error
//    }
//}

final class RealTranslationAPIService: TranslationAPIService {

    // MARK: - API infos.

    private enum APIInfos {
        static let googleAPIURL = "https://translation.googleapis.com/language/translate/v2?"
        static let googleAPIKey = "AIzaSyD2PKuGzRMcreo6MJu9c7SvTF5PsPR1fso"
    }

    // MARK: - Properties.

    var urlString: String = APIInfos.googleAPIURL + APIInfos.googleAPIKey

    // MARK: - Singleton pattern.

    static let shared: RealTranslationAPIService = .init()

    private init() {}

    // MARK: - Dependency injection.

    private var session: URLSession = .shared

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchTranslation(q: String, source: String, target: String, format: String ) async throws -> GoogleAPIResponse {

        let parameters = "&q=" + q
        + "&source=" + source
        + "&target=" + target
        + "&format=" + format 
        + "&key=" + APIInfos.googleAPIKey

        guard let url = URL(string: urlString + parameters) else { throw GoogleAPIError.invalidURL }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        let (data, response) = try await session.data(for: request)

        let result = checkStatusCode(urlResponse: response)

        switch result {

        case .success():

            return try JSONDecoder().decode(GoogleAPIResponse.self, from: data)

        case let .failure(failure):

            throw failure
        }
    }

    private func checkStatusCode(urlResponse: URLResponse) -> Result<Void, GoogleAPIError> {
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

struct GoogleAPIResponse: Codable {
    let data: GoogleAPITranslations
}

struct GoogleAPITranslations : Codable {
    let translations : [GoogleAPITranslationText]
}

struct GoogleAPITranslationText : Codable {
    let translatedText : String
}



enum GoogleAPIError: LocalizedError, CaseIterable {
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

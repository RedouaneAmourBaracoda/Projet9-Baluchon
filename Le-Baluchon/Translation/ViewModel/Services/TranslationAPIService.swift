//
//  TranslationAPIService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

protocol TranslationAPIService {
    func fetchTranslation(q: String, source: String, target: String, format: String) async throws -> GoogleAPIResponse
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
        static let ressource = "https://translation.googleapis.com/language/translate/v2?"
        static let key = "AIzaSyD2PKuGzRMcreo6MJu9c7SvTF5PsPR1fso"
        static var url = ressource + "key=" + key
    }

    // MARK: - Properties.

    var urlString: String = APIInfos.url

    // MARK: - Singleton pattern.

    static let shared: RealTranslationAPIService = .init()

    private init() {}

    // MARK: - Dependency injection.

    private var session: URLSession = .shared

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchTranslation(q: String, source: String, target: String, format: String) async throws -> GoogleAPIResponse {

        guard let url = URL(string: urlString) else { throw GoogleAPIError.invalidURL }

        var request = URLRequest(url: url)

        // HTTP Method.
        request.httpMethod = "POST"

        // HTTP Headers.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // HTTP Body.
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["q": q, "source": source, "target": target, "format": format])

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
            case 200: return .success(())

            case 400: return .failure(.bad_request)

            case 401: return .failure(.unauthorized)

            case 402: return .failure(.payment_required)

            case 403: return .failure(.forbidden)

            case 404: return .failure(.not_found)

            case 405: return .failure(.not_allowed)

            case 429: return .failure(.too_many_requests)

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
    case bad_request
    case unauthorized
    case payment_required
    case forbidden
    case not_found
    case not_allowed
    case too_many_requests
    case invalidRequest

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .bad_request:
            return NSLocalizedString("The client provided invalid query parameters for the request. It can be invalid fields, invalid values, or invalid api key.", comment: "")
        case .unauthorized:
            return NSLocalizedString("The client provided invalid credentials or the session has expired.", comment: "")
        case .payment_required:
            return NSLocalizedString("The client has exceeded the limit of daily requests and must upgrade the plan.", comment: "")
        case .forbidden:
            return NSLocalizedString("The requested operation is not allowed. It can be due to wrong access configuration, restricted access or exceeded limit of quotas for repeated over-use.", comment: "")
        case .not_found:
            return NSLocalizedString("The client requested a non-existent resource/route", comment: "")
        case .not_allowed:
            return NSLocalizedString("The http method for this request is not allowed. The client doesn’t have permission to access requested route/feature", comment: "")
        case .too_many_requests:
            return NSLocalizedString("The client has exceeded the limit of requests.", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "")
        }
    }
}

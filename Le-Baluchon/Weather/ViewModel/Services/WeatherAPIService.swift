//
//  TranslationAPIService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

protocol WeatherAPIService {
    func fetchWeather(cityName: String) async throws -> WeatherAPIResponse
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
//        guard let error else { return translationToReturn ?? .init(data: .init(translations: []))}
//
//        throw error
//    }
//}

final class RealWeatherAPIService: WeatherAPIService {

    // MARK: - API infos.

    private enum APIInfos {

        static let ressource = "https://api.openweathermap.org/data/2.5/weather?"

        static let key = "29aafb965a5a05167b697998854d37e9"

        static let languageCode = "fr"

        static let units = "metric"

        static let url = ressource + "appid=" + key + "&lang=" + languageCode + "&units=" + units + "&q="
    }

    // MARK: - Properties.

    var urlString: String = APIInfos.url

    // MARK: - Singleton pattern.

    static let shared: RealWeatherAPIService = .init()

    private init() {}

    // MARK: - Dependency injection.

    private var session: URLSession = .shared

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchWeather(cityName: String) async throws -> WeatherAPIResponse {

        guard let url = URL(string: urlString + cityName) else { throw WeatherAPIError.invalidURL }

        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        let result = checkStatusCode(urlResponse: response)

        switch result {

        case .success():

            return try JSONDecoder().decode(WeatherAPIResponse.self, from: data)

        case let .failure(failure):

            throw failure
        }
    }

    private func checkStatusCode(urlResponse: URLResponse) -> Result<Void, GoogleAPIError> {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return .failure(.invalidRequest) }

        let statusCode = httpURLResponse.statusCode

        print("STATUS CODE : \(statusCode)")

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

struct WeatherAPIResponse: Codable {
    let coord: Location
    let weather: [Weather]
    let main: Temperature
}

struct Location : Codable {
    let lon: Double
    let lat: Double
}

struct Weather : Codable {
    let id : Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature : Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
    let sea_level: Int
    let grnd_level: Int
}

enum WeatherAPIError: LocalizedError, CaseIterable {
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

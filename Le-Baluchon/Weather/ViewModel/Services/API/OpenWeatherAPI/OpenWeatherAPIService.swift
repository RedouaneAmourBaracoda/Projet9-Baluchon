//
//  TranslationAPIService.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

struct OpenWeatherAPIService: WeatherAPIServiceType {

    // MARK: - API infos.

    private enum APIInfos {

        static let ressource = "https://api.openweathermap.org/data/2.5/weather?"

        static let key = "29aafb965a5a05167b697998854d37e9"

        static let languageCode = "fr"

        static let units = "metric"

        static let url = ressource + "appid=" + key + "&lang=" + languageCode + "&units=" + units + "&q="
    }

    // MARK: - Properties.

    var urlString = APIInfos.url

    private var session: URLSession

    // MARK: - Dependency injection.

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchWeather(cityName: String) async throws -> WeatherModel {

        guard let url = URL(string: urlString + cityName) else { throw OpenWeatherAPIError.invalidURL }

        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        let result = OpenWeatherAPIError.checkStatusCode(urlResponse: response)

        switch result {

        case .success:

            return try JSONDecoder()
                .decode(OpenWeatherAPIResponse.self, from: data)
                .toWeatherModel

        case let .failure(failure):

            throw failure
        }
    }
}

//
//  WeatherModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 18/10/2024.
//

import Foundation

struct WeatherModel {
    let lon: Double
    let lat: Double
    let temperature: Double
    let humidity: Int
    var weatherDescription: WeatherDescription?

    init(weatherAPIResponse: WeatherAPIResponse) {
        self.lon = weatherAPIResponse.coord.lon
        self.lat = weatherAPIResponse.coord.lat
        self.temperature = weatherAPIResponse.main.temp
        self.humidity = weatherAPIResponse.main.humidity

        guard let code = weatherAPIResponse.weather.first?.id else { return }

        self.weatherDescription = .allCases.first(where: { $0.code.contains(code) }) ?? .clear
    }
}

enum WeatherDescription: String, CaseIterable {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case atmosphere
    case clear
    case clouds

    var code: ClosedRange<Int> {
        switch self {
        case .thunderstorm:
            200...232
        case .drizzle:
            300...321
        case .rain:
            500...531
        case .snow:
            600...622
        case .atmosphere:
            701...781
        case .clear:
            800...800
        case .clouds:
            801...804
        }
    }
}

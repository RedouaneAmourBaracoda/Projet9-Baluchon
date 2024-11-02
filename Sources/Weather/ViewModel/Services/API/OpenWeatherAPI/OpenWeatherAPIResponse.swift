//
//  OpenWeatherAPIResponse.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

struct OpenWeatherAPIResponse: Codable {
    private let coord: Location
    private let weather: [WeatherDescription]
    private let main: WeatherData
    private let name: String

    var toWeather: Weather {

        var weatherKind: WeatherKind = .undetermined

        if let code = weather.first?.id {

            switch code {
            case 200...232:
                weatherKind = .thunderstorm
            case 300...321:
                weatherKind = .drizzle
            case 500...531:
                weatherKind = .rain
            case 600...622:
                weatherKind = .snow
            case 701...781:
                weatherKind = .atmosphere
            case 800...800:
                weatherKind = .clear
            case 801...804:
                weatherKind = .clouds
            default:
                weatherKind = .undetermined
            }
        }

        return .init(
            city: name,
            lon: coord.lon,
            lat: coord.lat,
            temperature: Int(main.temp),
            temperatureFelt: Int(main.feels_like),
            temperatureMin: Int(main.temp_min),
            temperatureMax: Int(main.temp_max),
            humidity: main.humidity,
            pressure: main.pressure,
            description: weather.first?.description ?? Localizable.Weather.noWeatherDescription,
            weatherKind: weatherKind
        )
    }
}

private struct Location: Codable {
    let lon: Double
    let lat: Double
}

private struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// swiftlint:disable identifier_name
private struct WeatherData: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int
    let grnd_level: Int
}
// swiftlint:enable identifier_name

private extension Localizable.Weather {
    static let noWeatherDescription = NSLocalizedString(
        "weather.errors.no-description",
        comment: ""
    )
}

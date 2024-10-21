//
//  OpenWeatherAPIResponse.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

struct OpenWeatherAPIResponse: Codable {
    private let coord: Location
    private let weather: [Weather]
    private let main: WeatherData
    private let name: String

    var toWeatherModel: WeatherModel {

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
            temperature: main.temp,
            temperatureFelt: main.feels_like,
            temperatureMin: main.temp_min,
            temperatureMax: main.temp_max,
            humidity: main.humidity,
            pressure: main.pressure,
            description: weather.first?.description ?? "No description available",
            weatherKind: weatherKind
        )
    }
}

private struct Location : Codable {
    let lon: Double
    let lat: Double
}

private struct Weather : Codable {
    let id : Int
    let main: String
    let description: String
    let icon: String
}

private struct WeatherData : Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int
    let grnd_level: Int
}

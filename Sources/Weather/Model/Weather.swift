//
//  Weather.swift
//  Le-Baluchon
//
//  Created by Redouane on 18/10/2024.
//

import SwiftUI

struct Weather: Equatable {
    let city: String
    let lon: Double
    let lat: Double
    let temperature: Int
    let temperatureFelt: Int
    let temperatureMin: Int
    let temperatureMax: Int
    let humidity: Int
    let pressure: Int
    let description: String
    let weatherKind: WeatherKind

    public static func == (lhs: Weather, rhs: Weather) -> Bool {
        lhs.city == rhs.city
        && lhs.lat == rhs.lat
        && lhs.lon == rhs.lon
        && lhs.description == rhs.description
        && lhs.temperature == rhs.temperature
        && lhs.weatherKind == rhs.weatherKind
        && lhs.humidity == rhs.humidity
        && lhs.pressure == rhs.pressure
        && lhs.temperatureFelt == rhs.temperatureFelt
        && lhs.temperatureMin == rhs.temperatureMin
        && lhs.temperatureMax == rhs.temperatureMax
    }
}

enum WeatherKind: String, CaseIterable {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
    case undetermined

    var imageName: String {
        switch self {
        case .thunderstorm:
            return "cloud.bolt.rain"
        case .drizzle:
            return "cloud.drizzle"
        case .rain:
            return "cloud.heavyrain"
        case .snow:
            return "cloud.snow"
        case .atmosphere:
            return "cloud.fog"
        case .clear:
            return "sun.max"
        case .clouds:
            return "cloud"
        case .undetermined:
            return "questionmark"
        }
    }
}

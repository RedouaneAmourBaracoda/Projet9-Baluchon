//
//  WeatherModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 18/10/2024.
//

import Foundation

struct WeatherModel {
    let city: String
    let lon: Double
    let lat: Double
    let temperature: Double
    let temperatureFelt: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let humidity: Int
    let pressure: Int
    let description: String?
    let weatherKind: WeatherKind
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
            return "cloud.bolt.rain.fill"
        case .drizzle:
            return "cloud.drizzle.fill"
        case .rain:
            return "cloud.heavyrain.fill"
        case .snow:
            return "cloud.snow.fill"
        case .atmosphere:
            return "cloud.fog.fill"
        case .clear:
            return "sun.max.fill"
        case .clouds:
            return "cloud.circle.fill"
        case .undetermined:
            return "questionmark"

        }
    }
}

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

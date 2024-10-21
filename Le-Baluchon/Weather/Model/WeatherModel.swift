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
}

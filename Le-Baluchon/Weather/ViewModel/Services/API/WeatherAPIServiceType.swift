//
//  WeatherAPIServiceType.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol WeatherAPIServiceType {
    func fetchWeather(cityName: String) async throws -> WeatherModel
}

final class MockWeatherAPIService: WeatherAPIServiceType {

    var weatherToReturn: WeatherModel!

    var error: Error?

    var fetchWeatherCallsCounter = 0

    func fetchWeather(cityName: String) async throws -> WeatherModel {
        fetchWeatherCallsCounter += 1

        guard let error else { return weatherToReturn }

        throw error
    }
}

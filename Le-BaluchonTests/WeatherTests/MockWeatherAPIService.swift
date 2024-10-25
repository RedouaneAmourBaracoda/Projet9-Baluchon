//
//  MockWeatherAPIService.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 24/10/2024.
//

@testable import Le_Baluchon
import Foundation

final class MockWeatherAPIService: WeatherAPIService {

    var weatherToReturn: Weather!

    var error: Error?

    var fetchWeatherCallsCounter = 0

    func fetchWeather(cityName: String) async throws -> Weather {
        fetchWeatherCallsCounter += 1

        guard let error else { return weatherToReturn }

        throw error
    }
}

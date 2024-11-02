//
//  WeatherAPIServiceType.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol WeatherAPIService {
    func fetchWeather(cityName: String) async throws -> Weather
}

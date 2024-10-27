//
//  TranslationViewModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/09/2024.
//

import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {

    // MARK: - State

    @Published var inputCityName: String = ""

    @Published var weather: Weather?

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let weatherAPIService: WeatherAPIService

    // MARK: - Initializer.

    init(weatherAPIService: WeatherAPIService = OpenWeatherAPIService(), weather: Weather? = nil) {
        self.weatherAPIService = weatherAPIService
        self.weather = weather
    }

    // MARK: - Methods.

    func getWeather() async {
        do {
            weather = try await weatherAPIService.fetchWeather(cityName: inputCityName)
        } catch {
            if let weatherAPIError = error as? (any WeatherAPIError) {
                NSLog(weatherAPIError.errorDescription ?? .weatherUndeterminedErrorDescription)
                errorMessage = weatherAPIError.userFriendlyDescription
            } else {
                errorMessage = .weatherUndeterminedErrorDescription
            }
            shouldPresentAlert = true
        }
    }

    func clear() {
        inputCityName.removeAll()
    }
}

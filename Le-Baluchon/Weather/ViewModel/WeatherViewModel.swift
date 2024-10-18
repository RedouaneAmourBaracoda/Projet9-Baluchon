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

    @Published var temperature: Double?

    @Published var weatherDescription: String?

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let weatherAPIService: WeatherAPIService

    // MARK: - Initializer.

    init(weatherAPIService: WeatherAPIService) {
        self.weatherAPIService = weatherAPIService
    }

    // MARK: - Methods.

    func getWeather() async {
        do {
            let result = try await weatherAPIService.fetchWeather(cityName: inputCityName)
            let weatherModel: WeatherModel = .init(weatherAPIResponse: result)
            temperature = weatherModel.temperature
            weatherDescription = weatherModel.weatherDescription?.rawValue
        } catch {
            if let weatherAPIError = error as? WeatherAPIError {
                errorMessage = weatherAPIError.errorDescription ?? .undeterminedErrorDescription
            } else {
                errorMessage = .undeterminedErrorDescription
            }
            shouldPresentAlert = true
        }
    }
}

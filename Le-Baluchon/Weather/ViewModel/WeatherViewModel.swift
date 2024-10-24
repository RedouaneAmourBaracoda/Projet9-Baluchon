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

    @Published var weatherModel: WeatherModel?

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let weatherAPIService: WeatherAPIServiceType

    // MARK: - Initializer.

    init(weatherAPIService: WeatherAPIServiceType = OpenWeatherAPIService(), weatherModel: WeatherModel? = nil) {
        self.weatherAPIService = weatherAPIService
        self.weatherModel = weatherModel
    }

    // MARK: - Methods.

    func getWeather() async {
        do {
            weatherModel = try await weatherAPIService.fetchWeather(cityName: inputCityName)
        } catch {
            if let weatherAPIError = error as? LocalizedError {
                errorMessage = weatherAPIError.errorDescription ?? .weatherUndeterminedErrorDescription
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

extension String {
    static let weatherUndeterminedErrorDescription = "A non-determined error with weather services occured."
}

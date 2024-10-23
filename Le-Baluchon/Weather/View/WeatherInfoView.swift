//
//  WeatherInfoView.swift
//  Le-Baluchon
//
//  Created by Redouane on 22/10/2024.
//

import SwiftUI

struct WeatherInfoView: View {

    private let weatherModel: WeatherModel

    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }

    var body: some View {
        VStack {
            LocationInfoView(weatherModel: weatherModel)

            TemperatureInfoView(weatherModel: weatherModel)

            ComplementaryInfoView(weatherModel: weatherModel)
        }
    }
}

extension WeatherModel {
    static let forPreview = WeatherModel(
        city: "Paris",
        lon: 2.33,
        lat: 48.86,
        temperature: 25,
        temperatureFelt: 21,
        temperatureMin: 15,
        temperatureMax: 27,
        humidity: 70,
        pressure: 1110,
        description: "Ensoleillé",
        weatherKind: .clear
    )
}

#Preview {
    WeatherInfoView(weatherModel: .forPreview)
}

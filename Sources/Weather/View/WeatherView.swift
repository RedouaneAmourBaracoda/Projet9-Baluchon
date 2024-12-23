//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct WeatherView: View {

    @ObservedObject private var weatherViewModel: WeatherViewModel

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }

    var body: some View {
        NavigationStack {
            contentView()
                .alert(isPresented: $weatherViewModel.shouldPresentAlert) {
                    Alert(title: Text(Localizable.errorAlertTitle), message: Text(weatherViewModel.errorMessage))
                }
                .navigationTitle(Localizable.Weather.navigationTitle)
        }
    }

    private func contentView() -> some View {
        VStack {
            CitySearchFieldView(weatherViewModel: weatherViewModel)

            ScrollView {

                if let weather = weatherViewModel.weather {

                    LocationInfoView(weather: weather)

                    WeatherImageView(weather: weather)

                    TemperatureInfoView(weather: weather)

                    AdditionalInfoView(weather: weather)
                }
            }
        }
    }
}

#Preview {
    WeatherView(weatherViewModel: WeatherViewModel(weather: .forPreview))
}

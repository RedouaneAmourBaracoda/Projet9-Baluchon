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
            ViewThatFits {

                verticalLayoutView()

                horizontalLayoutView()
            }
            .ignoresSafeArea(.keyboard)
            .alert(isPresented: $weatherViewModel.shouldPresentAlert) {
                Alert(title: Text("Error"), message: Text(weatherViewModel.errorMessage))
            }
            .navigationTitle("Weather")
        }
    }

    private func verticalLayoutView() -> some View {
        ScrollView { // ScrollView is necessary to avoid keyboard push up.

            CitySearchFieldView(weatherViewModel: weatherViewModel)

            if let weather = weatherViewModel.weather {

                LocationInfoView(weather: weather)

                WeatherImageView(weather: weather)

                TemperatureInfoView(weather: weather)

                AdditionalInfoView(weather: weather)
            }
        }
    }

    private func horizontalLayoutView() -> some View {
        ScrollView { // ScrollView is necessary to avoid keyboard push up.

            CitySearchFieldView(weatherViewModel: weatherViewModel)

            if let weather = weatherViewModel.weather {

                LocationInfoView(weather: weather)

                HStack {
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

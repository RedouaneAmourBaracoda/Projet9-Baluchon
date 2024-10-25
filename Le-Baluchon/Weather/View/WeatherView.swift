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
            VStack {
                CitySearchFieldView(weatherViewModel: weatherViewModel)
                Spacer()
                weatherInfoView()
            }
            .alert(isPresented: $weatherViewModel.shouldPresentAlert) {
                Alert(title: Text("Error"), message: Text(weatherViewModel.errorMessage))
            }
            .navigationTitle("Weather")
        }
    }

    @ViewBuilder private func weatherInfoView() -> some View {
        if let weather = weatherViewModel.weather {
            VStack {
                Spacer()
                VStack {
                    LocationInfoView(weather: weather)
                    ViewThatFits {
                        verticalLayoutView(weather: weather)
                        horizontalLayoutView(weather: weather)
                    }
                }
                Spacer()
            }
        }
    }

    private func verticalLayoutView(weather: Weather) -> some View {
        VStack {
            WeatherImageView(weather: weather)
            TemperatureInfoView(weather: weather)
            AdditionalInfoView(weather: weather)
        }
    }

    private func horizontalLayoutView(weather: Weather) -> some View {
        HStack {
            WeatherImageView(weather: weather)
            TemperatureInfoView(weather: weather)
            AdditionalInfoView(weather: weather)
        }
    }
}

#Preview {
    WeatherView(weatherViewModel: WeatherViewModel(weather: .forPreview))
}

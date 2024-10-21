//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject private var weatherViewModel = WeatherViewModel()

    var body: some View {
        VStack {
            TextField(
                "Type a city",
                text: $weatherViewModel.inputCityName
            )
            .fontWeight(.thin)
            .padding()

            .onSubmit {
                Task {
                    await weatherViewModel.getWeather()
                }
            }

            Text("Temperature: \(weatherViewModel.weatherModel?.temperature ?? 0.0) °C")
            Text("Weather: \(weatherViewModel.weatherModel?.description ?? "")")
        }
        .alert(isPresented: $weatherViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(weatherViewModel.errorMessage))
        }
    }
}

#Preview {
    CurrencyView()
}

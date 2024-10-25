//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject private var weatherViewModel: WeatherViewModel

    @State private var onEditingChanged = false

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }

    var body: some View {
        VStack {
            citySearchView()
            Spacer()
            cityWeatherInfoView()
        }
        .alert(isPresented: $weatherViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(weatherViewModel.errorMessage))
        }
    }

    private func citySearchView() -> some View {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("City", text: $weatherViewModel.inputCityName, onEditingChanged: { onEditingChanged = $0
                })
                .fontWeight(.bold)
                .autocorrectionDisabled()
                .onSubmit {
                    Task {
                        await weatherViewModel.getWeather()
                    }
                }

                if onEditingChanged {
                    Button(action: {
                        weatherViewModel.clear()
                    }, label: {
                        Image(systemName: "xmark")
                            .padding(.trailing)
                            .foregroundStyle(.black)
                    })
                }
            }
            .padding()
            .withBackground()
    }

    @ViewBuilder private func cityWeatherInfoView() -> some View {
        if let weather = weatherViewModel.weather {
            VStack {
                Spacer()
                WeatherInfoView(weather: weather)
                Spacer()
            }
        }
    }
}

#Preview {
    WeatherView(weatherViewModel: WeatherViewModel(weather: .forPreview))
}

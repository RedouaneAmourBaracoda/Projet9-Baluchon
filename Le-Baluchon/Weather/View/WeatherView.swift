//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

// TODO: a faire :
/*

 -- Sortir le dossier resources de sources et ajouter un sous dossier preview content

 -- Sortir le info.plist dans un dossier “configuration”

 -- Unit tests: refactoriser les tests, des fonctions sont similaires.
 */

struct WeatherView: View {

    @ObservedObject private var weatherViewModel: WeatherViewModel

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }

    var body: some View {
        NavigationStack {
            contentView()
                .ignoresSafeArea(.keyboard)
                .alert(isPresented: $weatherViewModel.shouldPresentAlert) {
                    Alert(title: Text(Localizable.errorAlertTitle), message: Text(weatherViewModel.errorMessage))
                }
                .navigationTitle(Localizable.Weather.navigationTitle)
        }
    }

    private func contentView() -> some View {
        VStack {
            CitySearchFieldView(weatherViewModel: weatherViewModel)

            ScrollView { // ScrollView is necessary to avoid keyboard push up.

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

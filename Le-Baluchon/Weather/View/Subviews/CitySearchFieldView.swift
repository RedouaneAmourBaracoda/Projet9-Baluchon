//
//  CitySearchFieldView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct CitySearchFieldView: View {

    @ObservedObject private var weatherViewModel: WeatherViewModel

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
            TextField("City", text: $weatherViewModel.inputCityName)
                .fontWeight(.bold)
                .autocorrectionDisabled()
                .onSubmit {
                    Task {
                        await weatherViewModel.getWeather()
                    }
                }
        }
        .padding()
        .background { Color.gray.opacity(0.3) }
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding()
    }
}

#Preview {
    CitySearchFieldView(weatherViewModel: .init())
}

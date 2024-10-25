//
//  CitySearchFieldView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct CitySearchFieldView: View {

    @ObservedObject private var weatherViewModel: WeatherViewModel

    @State private var onEditingChanged = false

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }

    var body: some View {
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
}

#Preview {
    CitySearchFieldView(weatherViewModel: .init())
}

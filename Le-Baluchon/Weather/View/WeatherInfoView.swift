//
//  WeatherInfoView.swift
//  Le-Baluchon
//
//  Created by Redouane on 22/10/2024.
//

import SwiftUI

struct WeatherInfoView: View {

    private let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    var body: some View {
        VStack {
            LocationInfoView(weather: weather)
            ViewThatFits {
                verticalLayoutView()
                horizontalLayoutView()
            }
        }
    }

    private func verticalLayoutView() -> some View {
        VStack {
            WeatherImageView(weather: weather)
            TemperatureInfoView(weather: weather)
            ComplementaryInfoView(weather: weather)
        }
    }

    private func horizontalLayoutView() -> some View {
        HStack {
            WeatherImageView(weather: weather)
            TemperatureInfoView(weather: weather)
            ComplementaryInfoView(weather: weather)
        }
    }
}

#Preview {
    WeatherInfoView(weather: .forPreview)
}

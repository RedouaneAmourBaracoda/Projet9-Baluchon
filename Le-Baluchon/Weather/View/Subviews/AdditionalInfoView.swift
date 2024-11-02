//
//  SecondaryDataView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/10/2024.
//

import SwiftUI

struct AdditionalInfoView: View {

    private let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    var body: some View {
        HStack {
            temperatureFeltView()

            humidityView()

            pressureView()
        }
        .padding()
        .background { Color.gray.opacity(0.3) }
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding()
    }

    private func temperatureFeltView() -> some View {
        textView(name: Localizable.Weather.temperatureFeltTitle, value: weather.temperatureFelt, symbol: "°C")
    }

    private func humidityView() -> some View {
        textView(name: Localizable.Weather.humidityTitle, value: weather.humidity, symbol: "%")
    }

    private func pressureView() -> some View {
        textView(name: Localizable.Weather.pressureTitle, value: weather.pressure, symbol: "HPa")
    }

    private func textView(name: String, value: Int, symbol: String) -> some View {
        VStack {
            Text(name)
                .font(.subheadline)
            Text("\(value) \(symbol)")
                .fontWeight(.thin)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AdditionalInfoView(weather: .forPreview)
}

//
//  SecondaryDataView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/10/2024.
//

import SwiftUI

struct ComplementaryInfoView: View {

    private let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    var body: some View {
        HStack {
            temperatureFeltView()

            Divider()
                .frame(height: 50)

            humidityView()

            Divider()
                .frame(height: 50)

            pressureView()
        }
        .padding()
        .withBackground()
    }

    private func temperatureFeltView() -> some View {
        textView(name: "Feels", value: weather.temperatureFelt, symbol: "°C")
    }

    private func humidityView() -> some View {
        textView(name: "Humidity", value: weather.humidity, symbol: "%")
    }

    private func pressureView() -> some View {
        textView(name: "Pressure", value: weather.pressure, symbol: "HPa")
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
    ComplementaryInfoView(weather: .forPreview)
}

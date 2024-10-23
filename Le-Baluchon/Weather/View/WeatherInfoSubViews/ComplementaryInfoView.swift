//
//  SecondaryDataView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/10/2024.
//

import SwiftUI

struct ComplementaryInfoView: View {

    private let weatherModel: WeatherModel

    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
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
        textView(name: "Feels", value: weatherModel.temperatureFelt, symbol: "°C")
    }

    private func humidityView() -> some View {
        textView(name: "Humidity", value: weatherModel.humidity, symbol: "%")
    }

    private func pressureView() -> some View {
        textView(name: "Pressure", value: weatherModel.pressure, symbol: "HPa")
    }

    private func textView(name: String, value: Int, symbol: String) -> some View {
        VStack {
            Text(name)
                .bold()
            Text("\(value) \(symbol)")
                .fontWeight(.thin)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ComplementaryInfoView(weatherModel: .forPreview)
}

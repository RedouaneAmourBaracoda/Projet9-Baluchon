//
//  MainTemperatureView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/10/2024.
//

import SwiftUI

struct TemperatureInfoView: View {

    private let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    var body: some View {
        VStack(spacing: 8) {
            currentTemperarureInfoView()
            HStack {
                minTemperarureInfoView()
                maxTemperarureInfoView()
            }
            weatherDescriptionInfoView()
        }
    }

    private func currentTemperarureInfoView() -> some View {
        textView(
            name: "",
            value: String(weather.temperature),
            symbol: "°C",
            font: .title,
            weight: .bold,
            color: .black
        )
    }

    private func minTemperarureInfoView() -> some View {
        textView(
            name: "min :",
            value: String(weather.temperatureMax),
            symbol: "°C",
            font: .subheadline,
            weight: .thin,
            color: .black
        )
    }

    private func maxTemperarureInfoView() -> some View {
        textView(
            name: "max :",
            value: String(weather.temperatureMax),
            symbol: "°C",
            font: .subheadline,
            weight: .thin,
            color: .black
        )
    }

    private func weatherDescriptionInfoView() -> some View {
        textView(
            name: weather.description,
            value: nil,
            symbol: nil,
            font: .title2,
            weight: .thin,
            color: .black
        )
    }

    // swiftlint:disable:next function_parameter_count
    private func textView(
        name: String,
        value: String?,
        symbol: String?,
        font: Font,
        weight: Font.Weight,
        color: Color
    ) -> some View {
        Text("\(name) " + "\(value ?? "")"  + "\(symbol ?? "")")
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(color)
    }
}

#Preview {
    TemperatureInfoView(weather: .forPreview)
}

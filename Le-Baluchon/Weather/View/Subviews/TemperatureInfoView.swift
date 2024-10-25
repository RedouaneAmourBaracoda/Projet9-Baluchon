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
            description: nil,
            value: String(weather.temperature),
            symbol: "°C",
            font: .body,
            weight: .bold,
            color: .black
        )
    }

    private func minTemperarureInfoView() -> some View {
        textView(
            description: "min :",
            value: String(weather.temperatureMin),
            symbol: "°C",
            font: .subheadline,
            weight: .thin,
            color: .black
        )
    }

    private func maxTemperarureInfoView() -> some View {
        textView(
            description: "max :",
            value: String(weather.temperatureMax),
            symbol: "°C",
            font: .subheadline,
            weight: .thin,
            color: .black
        )
    }

    private func weatherDescriptionInfoView() -> some View {
        textView(
            description: weather.description,
            value: nil,
            symbol: nil,
            font: .body,
            weight: .thin,
            color: .black
        )
    }

    // swiftlint:disable:next function_parameter_count
    private func textView(
        description: String?,
        value: String?,
        symbol: String?,
        font: Font,
        weight: Font.Weight,
        color: Color
    ) -> some View {
        Text("\(description ?? "") " + "\(value ?? "")"  + "\(symbol ?? "")")
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(color)
    }
}

#Preview {
    TemperatureInfoView(weather: .forPreview)
}

//
//  MainTemperatureView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/10/2024.
//

import SwiftUI

struct TemperatureInfoView: View {

    private let weatherModel: WeatherModel

    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }

    var body: some View {
        VStack {
            imageView()
            temperaruresInfoView()
            Divider()
            weatherDescriptionInfoView()
        }
        .padding()
    }

    private func imageView() -> some View {
        weatherModel.weatherKind.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150)
            .padding()
    }

    private func temperaruresInfoView() -> some View {
        VStack {
            currentTemperarureInfoView()
            HStack {
                minTemperarureInfoView()
                maxTemperarureInfoView()
            }
        }
    }

    private func currentTemperarureInfoView() -> some View {
        textView(
            name: "",
            value: String(weatherModel.temperature),
            symbol: "°C",
            font: .largeTitle,
            weight: .bold,
            color: .black
        )
    }

    private func minTemperarureInfoView() -> some View {
        textView(
            name: "min :",
            value: String(weatherModel.temperatureMax),
            symbol: "°C",
            font: .subheadline,
            weight: .thin,
            color: .black
        )
    }

    private func maxTemperarureInfoView() -> some View {
        textView(
            name: "max :",
            value: String(weatherModel.temperatureMax),
            symbol: "°C",
            font: .subheadline,
            weight: .thin,
            color: .black
        )
    }

    private func weatherDescriptionInfoView() -> some View {
        textView(
            name: weatherModel.description,
            value: nil,
            symbol: nil,
            font: .title2,
            weight: .thin,
            color: .black
        )
        .padding()
    }

    private func textView(name: String, value: String?, symbol: String?, font: Font, weight: Font.Weight, color: Color) -> some View {
        Text("\(name) " + "\(value ?? "")"  + "\(symbol ?? "")")
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(color)
    }
}

#Preview {
    TemperatureInfoView(weatherModel: .forPreview)
}

//
//  LocationView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/10/2024.
//

import SwiftUI

struct LocationInfoView: View {

    private let weatherModel: WeatherModel

    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }

    var body: some View {
        VStack {
            cityNameView()
            coordinatesView()
        }
    }

    private func cityNameView() -> some View {
        HStack {
            Image(systemName: "location")
            textView(text: weatherModel.city, font: .title, weight: .bold, color: .black)
        }
    }

    private func coordinatesView() -> some View {
        HStack {
            longitudeInfoView()

            Divider()
                .frame(height: 20)

            latitudeInfoView()
        }
    }

    private func longitudeInfoView() -> some View {
        coordinateInfoView(name: "lon", value: weatherModel.lon)
    }

    private func latitudeInfoView() -> some View {
        coordinateInfoView(name: "lat", value: weatherModel.lat)
    }

    private func coordinateInfoView(name: String, value: Double) -> some View {
        textView(text: "\(name) : \(value) °", font: .subheadline, weight: .thin, color: .black)
    }

    private func textView(text: String, font: Font, weight: Font.Weight, color: Color) -> some View {
        Text(text)
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(color)
    }
}

#Preview {
    LocationInfoView(weatherModel: .forPreview)
}

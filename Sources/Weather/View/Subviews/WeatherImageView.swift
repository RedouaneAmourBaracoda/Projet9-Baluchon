//
//  WeatherImageView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct WeatherImageView: View {
    let weather: Weather

    var body: some View {
        Image(systemName: weather.weatherKind.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .padding()
    }
}

#Preview {
    WeatherImageView(weather: .forPreview)
}

//
//  Weather+Preview.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import Foundation

extension Weather {
    static let forPreview = Weather(
        city: "Paris",
        lon: 2.33,
        lat: 48.86,
        temperature: 25,
        temperatureFelt: 21,
        temperatureMin: 15,
        temperatureMax: 27,
        humidity: 70,
        pressure: 1110,
        description: "Ensoleillé",
        weatherKind: .clear
    )
}

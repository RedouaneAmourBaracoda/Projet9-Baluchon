//
//  Weather+Extensions.swift
//  Le-Baluchon
//
//  Created by Redouane on 24/10/2024.
//

import Foundation

extension Weather {
    static func random() -> Weather {
        .init(
            city: .random(),
            lon: .random(in: -180...180),
            lat: .random(in: -90...90),
            temperature: .random(in: -100...100),
            temperatureFelt: .random(in: -100...100),
            temperatureMin: .random(in: -100...100),
            temperatureMax: .random(in: -100...100),
            humidity: .random(in: 0...100),
            pressure: .random(in: -2000...2000),
            description: .random(),
            weatherKind: .allCases.randomElement() ?? .undetermined
        )
    }
}

extension String {
    static func random(length: Int = .random(in: 0...100)) -> String {
        String((0..<length).map { _ in letters.randomElement() ?? " " })
    }

    private static let letters = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

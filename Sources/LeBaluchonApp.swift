//
//  Le_BaluchonApp.swift
//  Le-Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import SwiftUI

// TODO: Review and test app.

@main
struct LeBaluchonApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CurrencyView()
                    .tabItem { Image(systemName: "dollarsign") }

                TranslationView()
                    .tabItem { Image(systemName: "textformat") }

                WeatherView(weatherViewModel: .init())
                    .tabItem { Image(systemName: "sun.min") }
            }
        }
    }
}

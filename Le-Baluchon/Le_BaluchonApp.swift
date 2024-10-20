//
//  Le_BaluchonApp.swift
//  Le-Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import SwiftUI

@main
struct Le_BaluchonApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CurrencyView()
                    .tabItem { Image(systemName: "dollarsign") }

                TranslationView()
                    .tabItem { Image(systemName: "textformat") }

                WeatherView()
                    .tabItem { Image(systemName: "sun.min") }
            }
        }
    }
}

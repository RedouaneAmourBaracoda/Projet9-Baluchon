//
//  CurrencyModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 05/09/2024.
//

import Foundation

enum LanguageItem: String, CaseIterable {
    case autoDetection = "Auto-detect"
    case english = "English"
    case french = "French"
    case spanish = "Spanish"

    var codeISO: String {
        switch self {
        case .autoDetection:
            ""
        case .english:
            "en"
        case .french:
            "fr"
        case .spanish:
            "es"
        }
    }

    var greetings: String {
        switch self {
        case .autoDetection:
            "Hello !"
        case .english:
            "Hello !"
        case .french:
            "Bonjour !"
        case .spanish:
            "¡Holà!"
        }
    }
}

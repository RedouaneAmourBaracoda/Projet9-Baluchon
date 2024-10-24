//
//  CurrencyModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 05/09/2024.
//

import Foundation

enum LanguageItem: String, CaseIterable {
    case autoDetection = "Auto-detect"
    case anglais = "Anglais"
    case français = "Français"
    case espagnol = "Espagnol"

    var codeISO: String {
        switch self {
        case .autoDetection:
            ""
        case .anglais:
            "en"
        case .français:
            "fr"
        case .espagnol:
            "es"
        }
    }

    var defaultWord: String {
        switch self {
        case .autoDetection:
            "Hello !"
        case .anglais:
            "Hello !"
        case .français:
            "Bonjour !"
        case .espagnol:
            "¡Holà!"
        }
    }
}

//
//  CurrencyModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 05/09/2024.
//

import Foundation

enum LanguageItem: String, CaseIterable {
    case anglais = "Anglais"
    case français = "Français"
    case espagnol = "Espagnol"

    var codeISO: String {
        switch self {
        case .anglais:
            "en"
        case .français:
            "fr"
        case .espagnol:
            "es"
        }
    }
}


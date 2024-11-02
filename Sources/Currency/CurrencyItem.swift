//
//  CurrencyModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 05/09/2024.
//

import Foundation

enum CurrencyItem: String, CaseIterable {
    case usDollar = "US Dollar"
    case euro = "Euro"
    case canadianDollar = "Canadian Dollar"
    case britishPound = "British Pound"
    case australianDollar = "Australian Dollar"

    var symbol: String {
        switch self {
        case .usDollar: return "$"
        case .euro: return "€"
        case .canadianDollar: return "$"
        case .britishPound: return "£"
        case .australianDollar: return "$"
        }
    }

    var identifier: String {
        switch self {
        case .usDollar: return "USD"
        case .euro: return "EUR"
        case .canadianDollar: return "CAD"
        case .britishPound: return "GBP"
        case .australianDollar: return "AUD"
        }
    }

    var flag: String {
        switch self {
        case .usDollar:
            "US-flag"
        case .euro:
            "UE-flag"
        case .canadianDollar:
            "Canadian-flag"
        case .britishPound:
           "GB-flag"
        case .australianDollar:
            "Australian-flag"
        }
    }
}

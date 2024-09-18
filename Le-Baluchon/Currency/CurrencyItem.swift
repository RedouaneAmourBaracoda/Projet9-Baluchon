//
//  CurrencyModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 05/09/2024.
//

import Foundation

enum CurrencyItem: String, CaseIterable {
    case USDollar = "US Dollar"
    case Euro = "Euro"
    case CanadianDollar = "Canadian Dollar"
    case BritishPound = "British Pound"
    case AustralianDollar = "Australian Dollar"

    var symbol: String {
        switch self {
        case .USDollar: return "$"
        case .Euro: return "€"
        case .CanadianDollar: return "$"
        case .BritishPound: return "£"
        case .AustralianDollar: return "$"
        }
    }

    var abreviation: String {
        switch self {
        case .USDollar: return "USD"
        case .Euro: return "EUR"
        case .CanadianDollar: return "CAD"
        case .BritishPound: return "GBP"
        case .AustralianDollar: return "AUD"
        }
    }

    var flag: String {
        switch self {
        case .USDollar:
            "US-flag"
        case .Euro:
            "UE-flag"
        case .CanadianDollar: 
            "Canadian-flag"
        case .BritishPound:
           "GB-flag"
        case .AustralianDollar:
            "Australian-flag"
        }
    }
}

//
//  CurrencyModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 05/09/2024.
//

import UIKit
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

    var flag: UIImage {
        switch self {
        case .USDollar: return UIImage(resource: .init(name: "US-flag", bundle: .main))
        case .Euro:
            return UIImage(resource: .init(name: "UE-flag", bundle: .main))
        case .CanadianDollar:
            return UIImage(resource: .init(name: "Canadian-flag", bundle: .main))
        case .BritishPound:
            return UIImage(resource: .init(name: "GB-flag", bundle: .main))
        case .AustralianDollar:
            return UIImage(resource: .init(name: "Australian-flag", bundle: .main))
        }
    }
}

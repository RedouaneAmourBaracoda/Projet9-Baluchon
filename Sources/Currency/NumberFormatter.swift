//
//  NumberFormatter.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.decimalSeparator = Locale.current.decimalSeparator
        return formatter
    }()
}

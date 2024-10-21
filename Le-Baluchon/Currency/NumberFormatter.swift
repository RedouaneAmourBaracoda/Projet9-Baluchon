//
//  NumberFormatter.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

extension NumberFormatter {
    static let valueFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

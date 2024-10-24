//
//  CurrencyAPIServiceType.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol CurrencyAPIService {
    func fetchCurrency() async throws -> [String: Double]
}

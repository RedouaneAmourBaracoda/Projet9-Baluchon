//
//  CurrencyAPIServiceType.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol CurrencyAPIServiceType {
    func fetchCurrency() async throws -> [String: Double]
}

final class MockCurrencyAPIService: CurrencyAPIServiceType {

    var ratesToReturn: [String: Double]!

    var error: Error?

    var fetchCurrencyCallsCounter = 0

    func fetchCurrency() async throws -> [String: Double] {
        fetchCurrencyCallsCounter += 1

        guard let error else { return ratesToReturn }

        throw error
    }
}

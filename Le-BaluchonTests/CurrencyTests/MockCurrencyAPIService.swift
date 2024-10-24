//
//  MockCurrencyAPIService.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 24/10/2024.
//

@testable import Le_Baluchon
import Foundation

final class MockCurrencyAPIService: CurrencyAPIService {

    var ratesToReturn: [String: Double]!

    var error: Error?

    var fetchCurrencyCallsCounter = 0

    func fetchCurrency() async throws -> [String: Double] {
        fetchCurrencyCallsCounter += 1

        guard let error else { return ratesToReturn }

        throw error
    }
}

//
//  MockCurrencyService.swift
//  Le-BaluchonTests
//
//  Created by Damien Rivet on 23/08/2024.
//

@testable import Le_Baluchon
import Foundation

final class MockCurrencyService: CurrencyAPIService {

    // MARK: - Properties

    var currencyToReturn: ExpectedCurrency?

    init(urlSession: URLSession = .shared) {
        
    }

    // MARK: - Functions

    func fetchCurrency(baseCurrency: String, convertToCurrency: String) async throws -> ExpectedCurrency {
        return if let currencyToReturn {
            currencyToReturn
        } else {
            ExpectedCurrency(data: [:])
        }
    }
}

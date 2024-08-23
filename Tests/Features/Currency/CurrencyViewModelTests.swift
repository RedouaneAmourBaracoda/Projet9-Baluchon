//
//  CurrencyViewModelTests.swift
//  Le-BaluchonTests
//
//  Created by Damien Rivet on 23/08/2024.
//

@testable import Le_Baluchon
import XCTest

final class CurrencyViewModelTests: XCTestCase {

    // MARK: - Properties

    private var currencyService: MockCurrencyService!
    private var viewModel: CurrencyViewModel!

    // MARK: - Functions

    override func setUp() {
        currencyService = MockCurrencyService()

        viewModel = CurrencyViewModel(currencyService: currencyService)
    }

    // MARK: - Tests

    func test_ShouldReturnConvertedCurrency() async {
        // Given
        currencyService.currencyToReturn = ExpectedCurrency(data: ["EUR": 1.1])

        // When
        await viewModel.fetchCurrency(baseCurrency: "USD", convertToCurrency: "EUR", baseValue: 100)

        // Then
        XCTAssertEqual(viewModel.value, 110)
    }
}

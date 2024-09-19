//
//  CurrencyViewModelTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 18/09/2024.
//

@testable import Le_Baluchon
import XCTest

@MainActor 
final class CurrencyViewModelTests: XCTestCase {

    var currencyViewModel: CurrencyViewModel!

    var dataStoreService: MockDataStoreService!

    var currencyAPIService: MockCurrencyAPIService!

    override func setUpWithError() throws {

        currencyAPIService = MockCurrencyAPIService()

        dataStoreService = MockDataStoreService()

        currencyViewModel = .init(currencyApiService: currencyAPIService, dataStoreService: dataStoreService)
    }

    func testUpdateIsNeededWhenNoDataSaved() {

        // Given.

        dataStoreService.persistedDate = nil

        dataStoreService.persistedRates = nil

        // When.

        let shouldUpdateRates = currencyViewModel.testShouldUpdateRates()

        // Then

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 1)

        XCTAssertTrue(shouldUpdateRates)
    }

    func testUpdateIsNeededWhenLastUpdateExceeds1Hour() {

        // Given.

        dataStoreService.persistedDate = Date.now.advanced(by: -3700).timeIntervalSince1970

        dataStoreService.persistedRates = .init()

        // When.

        let shouldUpdateRates = currencyViewModel.testShouldUpdateRates()

        // Then
        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 1)

        XCTAssertTrue(shouldUpdateRates)
    }

    func testUpdateIsNotNeededWhenLastUpdateIsLessThan1Hour() {

        // Given.

        dataStoreService.persistedDate = Date.now.advanced(by: -3500).timeIntervalSince1970

        dataStoreService.persistedRates = .init()

        // When.

        let shouldUpdateRates = currencyViewModel.testShouldUpdateRates()

        // Then
        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 1)

        XCTAssertFalse(shouldUpdateRates)
    }
}

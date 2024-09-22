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

        let shouldUpdateRates = currencyViewModel.shouldUpdateRates()

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

        let shouldUpdateRates = currencyViewModel.shouldUpdateRates()

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

        let shouldUpdateRates = currencyViewModel.shouldUpdateRates()

        // Then

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 1)

        XCTAssertFalse(shouldUpdateRates)
    }

    // Testing no data is saved when the API service returns an http error.
    func testGetCurrencyWhenAPIReturnsHTTPError() async {

        // Given.

        let error: HTTPError? = .allCases.randomElement()

        currencyAPIService.error = error

        currencyAPIService.ratesToReturn = nil

        // When.

        await currencyViewModel.getCurrency()

        // Then.

        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 0)

        XCTAssertNil(dataStoreService.persistedDate)

        XCTAssertNil(dataStoreService.persistedRates)

        XCTAssertTrue(currencyViewModel.shouldPresentAlert)

        XCTAssertEqual(currencyViewModel.errorMessage, error?.errorDescription)
    }

    // Testing no data was saved when the API service returns a random error.
    func testGetCurrencyWhenAPIReturnsOtherError() async {

        // Given.

        let error: Error = NSError()

        currencyAPIService.error = error

        currencyAPIService.ratesToReturn = nil

        // When.

        await currencyViewModel.getCurrency()

        // Then.

        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 0)

        XCTAssertNil(dataStoreService.persistedDate)

        XCTAssertNil(dataStoreService.persistedRates)

        XCTAssertTrue(currencyViewModel.shouldPresentAlert)

        XCTAssertEqual(currencyViewModel.errorMessage, .undeterminedErrorDescription)
    }



    // Testing data was saved when the API service returns a value.
    func testGetCurrencyWhenAPIReturnsValue() async {

        // Given.

        currencyAPIService.error = nil

        currencyAPIService.ratesToReturn = .init(rates: [:])

        dataStoreService.persistedDate = nil

        dataStoreService.persistedRates = nil

        // When.

        await currencyViewModel.getCurrency()

        // Then.

        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 1)

        XCTAssertNotNil(dataStoreService.retrieveDate())

        XCTAssertEqual(dataStoreService.retrieveRates(), [:])

        XCTAssertFalse(currencyViewModel.shouldPresentAlert)

        XCTAssertTrue(currencyViewModel.errorMessage.isEmpty)
    }

    func testConvertWhenNoDataSaved() async {

        // Given.

        dataStoreService.persistedDate = nil

        dataStoreService.persistedRates = nil

        currencyViewModel.baseCurrency = .Euro

        currencyViewModel.baseValue = 1000

        currencyViewModel.targetCurrency = .BritishPound

        currencyAPIService.ratesToReturn = .init(rates: ["AUD": 1.470805, "CAD": 1.35835, "EUR": 0.895215, "GBP": 0.75061])

        // When.

        await currencyViewModel.convert()

        // Then.

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 2)

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        // "shouldUpdate()" was true.
        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 1)

        XCTAssertEqual(currencyAPIService.ratesToReturn?.rates, dataStoreService.retrieveRates())

        XCTAssertNotNil(dataStoreService.retrieveDate())

        XCTAssertFalse(currencyViewModel.shouldPresentAlert)

        XCTAssertTrue(currencyViewModel.errorMessage.isEmpty)

        let expectedValue = 1000 * (0.75061 / 0.895215)

        let expectedOutput = NumberFormatter.valueFormatter.string(from: NSNumber(value: expectedValue))

        XCTAssertEqual(expectedOutput, currencyViewModel.outputString)
    }

    func testConvertWhenDataWasAlreadySavedLessThan1Hour() async {

        // Given.

        dataStoreService.persistedDate = Date.now.timeIntervalSince1970

        dataStoreService.persistedRates = ["AUD": 1.470805, "CAD": 1.35835, "EUR": 0.895215, "GBP": 0.75061]

        currencyViewModel.baseCurrency = .Euro

        currencyViewModel.baseValue = 1000

        currencyViewModel.targetCurrency = .BritishPound

        // When.

        await currencyViewModel.convert()

        // Then.

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 2)

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        // "shouldUpdate()" was false.
        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 0)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 0)

        XCTAssertFalse(currencyViewModel.shouldPresentAlert)

        XCTAssertTrue(currencyViewModel.errorMessage.isEmpty)

        let expectedValue = 1000 * (0.75061 / 0.895215)

        let expectedOutput = NumberFormatter.valueFormatter.string(from: NSNumber(value: expectedValue))

        XCTAssertEqual(expectedOutput, currencyViewModel.outputString)
    }

    func testConvertWhenDataWasAlreadySavedMoreThan1Hour() async {

        // Given.

        dataStoreService.persistedDate = Date().advanced(by: -4000).timeIntervalSince1970

        // Old rates.
        dataStoreService.persistedRates = ["AUD": 1.470805, "CAD": 1.35835, "EUR": 0.895215, "GBP": 0.75061]

        // New rates.
        currencyAPIService.ratesToReturn = .init(rates: ["AUD": 1.52175, "CAD": 1.23841, "EUR": 0.915235, "GBP": 0.70001])

        currencyViewModel.baseCurrency = .AustralianDollar

        currencyViewModel.baseValue = 1000

        currencyViewModel.targetCurrency = .CanadianDollar

        // When.

        await currencyViewModel.convert()

        // Then.

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 2)

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        // "shouldUpdate()" was true.
        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 1)

        XCTAssertFalse(currencyViewModel.shouldPresentAlert)

        XCTAssertTrue(currencyViewModel.errorMessage.isEmpty)

        let expectedValue = 1000 * (1.23841 / 1.52175)

        let expectedOutput = NumberFormatter.valueFormatter.string(from: NSNumber(value: expectedValue))

        XCTAssertEqual(expectedOutput, currencyViewModel.outputString)
    }

    func testSwapCurrencies() {

        // Given.

        currencyViewModel.baseCurrency = .BritishPound

        currencyViewModel.targetCurrency = .Euro

        // When.

        currencyViewModel.swapCurrencies()

        // Then.

        XCTAssertEqual(currencyViewModel.baseCurrency, .Euro)

        XCTAssertEqual(currencyViewModel.targetCurrency, .BritishPound)
    }
}

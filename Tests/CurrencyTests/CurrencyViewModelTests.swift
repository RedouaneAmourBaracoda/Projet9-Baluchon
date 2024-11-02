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

    func testNoConversionWhenInputBaseIsEmpty() async {

        // Given.

        currencyViewModel.inputString = ""

        // When.

        await currencyViewModel.convert()

        // Then

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 0)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 0)

        guard let outputString = currencyViewModel.outputString else {
            XCTFail("Output string is nil.")
            return
        }

        XCTAssertTrue(outputString.isEmpty)
    }

    func testNoConversionWhenInputBaseIsInvalid() async {

        // Given.

        currencyViewModel.inputString = "100A1"

        // When.

        await currencyViewModel.convert()

        // Then

        XCTAssertEqual(currencyViewModel.errorMessage, "Invalid number.")

        XCTAssertTrue(currencyViewModel.shouldPresentAlert)

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 0)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 0)

        XCTAssertNil(currencyViewModel.outputString)
    }

    func testUpdateIsNeededWhenNoDataSaved() {

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

        dataStoreService.persistedRates = [:]

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

        dataStoreService.persistedRates = [:]

        // When.

        let shouldUpdateRates = currencyViewModel.shouldUpdateRates()

        // Then

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 1)

        XCTAssertFalse(shouldUpdateRates)
    }

    // Testing no data is saved when the OpenExchange API service returns an error.
    func testGetCurrencyWhenOpenExchangeAPIReturnsError() async {

        // Given.

        let error = OpenExchangeAPIError.allCases.randomElement()

        currencyAPIService.error = error

        // When.

        await currencyViewModel.getCurrency()

        // Then.

        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 0)

        XCTAssertNil(dataStoreService.persistedDate)

        XCTAssertNil(dataStoreService.persistedRates)

        XCTAssertTrue(currencyViewModel.shouldPresentAlert)

        XCTAssertEqual(currencyViewModel.errorMessage, error?.userFriendlyDescription)
    }

    // Testing no data was saved when an API service returns a random error.
    func testGetCurrencyWhenOpenExchangeAPIReturnsOtherError() async {

        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error: Error = NSError()

        currencyAPIService.error = error

        // When.

        await currencyViewModel.getCurrency()

        // Then.

        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 0)

        XCTAssertNil(dataStoreService.persistedDate)

        XCTAssertNil(dataStoreService.persistedRates)

        XCTAssertTrue(currencyViewModel.shouldPresentAlert)

        XCTAssertEqual(currencyViewModel.errorMessage, Localizable.Currency.undeterminedErrorDescription)
    }

    // Testing data was saved when an API service returns a value.
    func testGetCurrencyWhenAPIReturnsValue() async {

        // Given.

        currencyAPIService.ratesToReturn = [:]

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

        currencyViewModel.baseCurrency = .euro

        currencyViewModel.inputString = "1000"

        currencyViewModel.targetCurrency = .britishPound

        currencyAPIService.ratesToReturn = ["AUD": 1.470805, "CAD": 1.35835, "EUR": 0.895215, "GBP": 0.75061]

        // When.

        await currencyViewModel.convert()

        // Then.

        XCTAssertEqual(dataStoreService.retrieveRatesCallsCounter, 2)

        XCTAssertEqual(dataStoreService.retrieveDateCallsCounter, 1)

        // "shouldUpdate()" was true.
        XCTAssertEqual(currencyAPIService.fetchCurrencyCallsCounter, 1)

        XCTAssertEqual(dataStoreService.saveCallsCounter, 1)

        XCTAssertEqual(currencyAPIService.ratesToReturn, dataStoreService.retrieveRates())

        XCTAssertNotNil(dataStoreService.retrieveDate())

        XCTAssertFalse(currencyViewModel.shouldPresentAlert)

        XCTAssertTrue(currencyViewModel.errorMessage.isEmpty)

        let expectedValue = 1000 * (0.75061 / 0.895215)

        let expectedOutput = NumberFormatter.currencyFormatter.string(from: NSNumber(value: expectedValue))

        XCTAssertEqual(expectedOutput, currencyViewModel.outputString)
    }

    func testConvertWhenDataWasAlreadySavedLessThan1Hour() async {

        // Given.

        dataStoreService.persistedDate = Date.now.timeIntervalSince1970

        dataStoreService.persistedRates = ["AUD": 1.470805, "CAD": 1.35835, "EUR": 0.895215, "GBP": 0.75061]

        currencyViewModel.baseCurrency = .euro

        currencyViewModel.inputString = "1000"

        currencyViewModel.targetCurrency = .britishPound

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

        let expectedOutput = NumberFormatter.currencyFormatter.string(from: NSNumber(value: expectedValue))

        XCTAssertEqual(expectedOutput, currencyViewModel.outputString)
    }

    func testConvertWhenDataWasAlreadySavedMoreThan1Hour() async {

        // Given.

        dataStoreService.persistedDate = Date().advanced(by: -4000).timeIntervalSince1970

        // Old rates.
        dataStoreService.persistedRates = ["AUD": 1.470805, "CAD": 1.35835, "EUR": 0.895215, "GBP": 0.75061]

        // New rates.
        currencyAPIService.ratesToReturn = ["AUD": 1.52175, "CAD": 1.23841, "EUR": 0.915235, "GBP": 0.70001]

        currencyViewModel.baseCurrency = .australianDollar

        currencyViewModel.inputString = "1000"

        currencyViewModel.targetCurrency = .canadianDollar

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

        let expectedOutput = NumberFormatter.currencyFormatter.string(from: NSNumber(value: expectedValue))

        XCTAssertEqual(expectedOutput, currencyViewModel.outputString)
    }

    func testSwapCurrencies() {

        // Given.

        let initialBaseCurrency = CurrencyItem.allCases.randomElement() ?? .britishPound

        let initialTargetCurrency = CurrencyItem.allCases.randomElement() ?? .euro

        currencyViewModel.baseCurrency = initialBaseCurrency

        currencyViewModel.targetCurrency = initialTargetCurrency

        // When.

        currencyViewModel.swapCurrencies()

        // Then.

        XCTAssertEqual(currencyViewModel.baseCurrency, initialTargetCurrency)

        XCTAssertEqual(currencyViewModel.targetCurrency, initialBaseCurrency)
    }
}

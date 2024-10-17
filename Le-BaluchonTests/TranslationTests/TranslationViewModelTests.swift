//
//  CurrencyViewModelTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 18/09/2024.
//

@testable import Le_Baluchon
import XCTest

@MainActor
final class TranslationViewModelTests: XCTestCase {

    var translationViewModel: TranslationViewModel!

    var translationAPIService: MockTranslationAPIService!

    override func setUpWithError() throws {

        translationAPIService = MockTranslationAPIService()

        translationViewModel = .init(translationAPIService: translationAPIService)
    }

    func testClear() async {

        // Given.

        translationViewModel.inputText = LanguageItem.anglais.defaultWord

        translationViewModel.outputText = LanguageItem.français.defaultWord

        XCTAssertFalse(translationViewModel.inputText.isEmpty)

        XCTAssertFalse(translationViewModel.outputText.isEmpty)

        // When.

        translationViewModel.clear()

        // Then.

        XCTAssertTrue(translationViewModel.inputText.isEmpty)

        XCTAssertTrue(translationViewModel.outputText.isEmpty)
    }

    func testSwapLanguages() async {

        // Given.

        translationViewModel.baseLanguageItem = .français

        translationViewModel.targetLanguageItem = .espagnol

        // When.

        translationViewModel.swapLanguages()

        // Then.

        XCTAssertEqual(translationViewModel.baseLanguageItem, .espagnol)

        XCTAssertEqual(translationViewModel.targetLanguageItem, .français)
    }

    // Testing no fetch when input string is empty.
    func testTranslateWhenInputStringIsEmpty() async {

        // Given.

        translationViewModel.inputText = ""

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 0)

        XCTAssertTrue(translationViewModel.outputText.isEmpty)
    }

    // Testing no fetch when base language and target languages are the same.
    func testTranslateWhenBaseLanguageAndTargetLanguageAreIdentical() async {

        // Given.

        guard let randomLanguageItem = LanguageItem.allCases.randomElement() else { return }

        translationViewModel.baseLanguageItem = randomLanguageItem

        translationViewModel.targetLanguageItem = randomLanguageItem

        translationViewModel.inputText = randomLanguageItem.defaultWord

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 0)

        XCTAssertEqual(translationViewModel.outputText, translationViewModel.inputText)
    }

    func testTranslateWhenAPIReturnsError() async {

        // Given.

        let error: GoogleAPIError? = .allCases.randomElement()

        translationAPIService.error = error

        translationAPIService.translationToReturn = nil

        translationViewModel.baseLanguageItem = .anglais

        translationViewModel.targetLanguageItem = .français

        translationViewModel.inputText = translationViewModel.baseLanguageItem.defaultWord

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 1)

        XCTAssertTrue(translationViewModel.shouldPresentAlert)

        XCTAssertEqual(translationViewModel.errorMessage, error?.errorDescription)

        XCTAssertTrue(translationViewModel.outputText.isEmpty)
    }

    // Testing when the API service returns a random error.
    func testTranslateWhenAPIReturnsOtherError() async {

        // Given.

        let error = NSError()

        translationAPIService.error = error

        translationAPIService.translationToReturn = nil

        translationViewModel.baseLanguageItem = .anglais

        translationViewModel.targetLanguageItem = .français

        translationViewModel.inputText = translationViewModel.baseLanguageItem.defaultWord

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 1)

        XCTAssertTrue(translationViewModel.shouldPresentAlert)

        XCTAssertEqual(translationViewModel.errorMessage, .undeterminedErrorDescription)
    }

    func testTranslateIsSuccessWhenNoErrors() async {

        // Given.

        let baseLanguageItem: LanguageItem = .anglais

        let targetLanguageItem: LanguageItem = .espagnol

        translationViewModel.baseLanguageItem = baseLanguageItem

        translationViewModel.targetLanguageItem = targetLanguageItem

        translationViewModel.inputText = baseLanguageItem.defaultWord

        translationAPIService.translationToReturn = .init(data: .init(translations: [.init(translatedText: targetLanguageItem.defaultWord)]))

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 1)

        XCTAssertEqual(translationViewModel.outputText, targetLanguageItem.defaultWord)

        XCTAssertTrue(translationViewModel.errorMessage.isEmpty)

        XCTAssertFalse(translationViewModel.shouldPresentAlert)
    }
}

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

        translationViewModel.inputText = LanguageItem.english.greetings

        translationViewModel.outputText = LanguageItem.french.greetings

        // When.

        translationViewModel.clear()

        // Then.

        XCTAssertTrue(translationViewModel.inputText.isEmpty)

        XCTAssertTrue(translationViewModel.outputText.isEmpty)
    }

    func testSwapLanguages() async {

        // Given.

        translationViewModel.baseLanguageItem = .french

        translationViewModel.targetLanguageItem = .spanish

        // When.

        translationViewModel.swapLanguages()

        // Then.

        XCTAssertEqual(translationViewModel.baseLanguageItem, .spanish)

        XCTAssertEqual(translationViewModel.targetLanguageItem, .french)
    }

    func testNoTranslationWhenInputStringIsEmpty() async {

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

        translationViewModel.inputText = randomLanguageItem.greetings

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 0)

        XCTAssertEqual(translationViewModel.outputText, translationViewModel.inputText)
    }

    func testTranslateWhenGoogleTranslationAPIReturnsError() async {

        // Given.

        let error = GoogleTranslationAPIError.allCases.randomElement()

        translationAPIService.error = error

        translationViewModel.baseLanguageItem = .english

        translationViewModel.targetLanguageItem = .french

        translationViewModel.inputText = translationViewModel.baseLanguageItem.greetings

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 1)

        XCTAssertTrue(translationViewModel.shouldPresentAlert)

        XCTAssertEqual(translationViewModel.errorMessage, error?.userFriendlyDescription)

        XCTAssertTrue(translationViewModel.outputText.isEmpty)
    }

    // Testing when the TranslationAPI returns a random error.
    func testTranslateWhenTranslationAPIReturnsOtherError() async {

        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        translationAPIService.error = error

        translationViewModel.baseLanguageItem = .english

        translationViewModel.targetLanguageItem = .french

        translationViewModel.inputText = translationViewModel.baseLanguageItem.greetings

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 1)

        XCTAssertTrue(translationViewModel.shouldPresentAlert)

        XCTAssertEqual(translationViewModel.errorMessage, Localizable.Translation.undeterminedErrorDescription)
    }

    func testTranslateIsSuccessWhenNoErrors() async {

        // Given.

        let baseLanguageItem: LanguageItem = .english

        let targetLanguageItem: LanguageItem = .spanish

        let randomTranslation: String = .random()

        translationViewModel.baseLanguageItem = baseLanguageItem

        translationViewModel.targetLanguageItem = targetLanguageItem

        translationViewModel.inputText = baseLanguageItem.greetings

        translationAPIService.textToReturn = randomTranslation

        // When.

        await translationViewModel.translate()

        // Then.

        XCTAssertEqual(translationAPIService.fetchTranslationCallsCounter, 1)

        XCTAssertEqual(translationViewModel.outputText, randomTranslation)

        XCTAssertTrue(translationViewModel.errorMessage.isEmpty)

        XCTAssertFalse(translationViewModel.shouldPresentAlert)
    }
}

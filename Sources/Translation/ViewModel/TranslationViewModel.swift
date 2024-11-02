//
//  TranslationViewModel.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/09/2024.
//

import SwiftUI

@MainActor
final class TranslationViewModel: ObservableObject {

    // MARK: - State

    @Published var baseLanguageItem: LanguageItem = .english

    @Published var targetLanguageItem: LanguageItem = .french

    @Published var inputText: String = ""

    @Published var outputText: String = ""

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let translationAPIService: TranslationAPIService

    // MARK: - Initializer.

    init(translationAPIService: TranslationAPIService = GoogleTranslationAPIService()) {
        self.translationAPIService = translationAPIService
    }

    // MARK: - Methods.

    func translate() async {

        guard !inputText.isEmpty else {
            clear()
            return
        }

        guard baseLanguageItem != targetLanguageItem else {
            outputText = inputText
            return
        }

        do {
            outputText = try await translationAPIService.fetchTranslation(
                text: inputText,
                source: baseLanguageItem.codeISO,
                target: targetLanguageItem.codeISO,
                format: "text"
            )
        } catch {
            if let translationAPIError = error as? (any TranslationAPIError) {
                NSLog(translationAPIError.errorDescription ?? Localizable.Translation.undeterminedErrorDescription)
                errorMessage = translationAPIError.userFriendlyDescription
            } else {
                errorMessage = Localizable.Translation.undeterminedErrorDescription
            }
            clear()
            shouldPresentAlert = true
        }
    }

    func clear() {
        inputText.removeAll()
        outputText.removeAll()
    }

    func swapLanguages() {
        let initialBaseLanguage = baseLanguageItem
        baseLanguageItem = targetLanguageItem
        targetLanguageItem = initialBaseLanguage
    }
}

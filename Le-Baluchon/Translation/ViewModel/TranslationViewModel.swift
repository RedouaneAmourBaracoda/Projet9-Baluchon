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

    @Published var baseLanguageItem: LanguageItem = .anglais

    @Published var targetLanguageItem: LanguageItem = .français

    @Published var inputText: String = ""

    @Published var outputText: String = ""

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let translationAPIService: TranslationAPIServiceType

    // MARK: - Initializer.

    init(translationAPIService: TranslationAPIServiceType = GoogleTranslationAPIService()) {
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
                q: inputText,
                source: baseLanguageItem.codeISO,
                target: targetLanguageItem.codeISO,
                format: "text"
            )
        } catch {
            if let translationAPIError = error as? LocalizedError {
                errorMessage = translationAPIError.errorDescription ?? .translationUndeterminedErrorDescription
            } else {
                errorMessage = .translationUndeterminedErrorDescription
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

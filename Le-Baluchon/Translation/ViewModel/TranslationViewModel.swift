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

    var errorMessage: String = ""

    // MARK: - Services.

    private let translationAPIService: TranslationAPIService

    // MARK: - Initializer.

    init(translationAPIService: TranslationAPIService) {
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
            let result = try await translationAPIService.fetchTranslation(
                q: inputText,
                source: baseLanguageItem.codeISO,
                target: targetLanguageItem.codeISO,
                format: "text"
            )
            outputText = result.data.translations.first?.translatedText ?? "Error."
        } catch {
            print(error)
        }
    }

    func clear() {
        inputText = ""
        outputText = ""
    }

    func swapLanguages() {
        let initialBaseLanguage = baseLanguageItem
        baseLanguageItem = targetLanguageItem
        targetLanguageItem = initialBaseLanguage
    }
}

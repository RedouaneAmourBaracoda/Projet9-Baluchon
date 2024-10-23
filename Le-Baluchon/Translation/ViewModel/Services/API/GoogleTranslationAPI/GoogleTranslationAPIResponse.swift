//
//  GoogleAPIResponse.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

struct GoogleTranslationAPIResponse: Codable {
    private let data: Translations

    var toString: String {
        data.translations.first?.translatedText ?? "No translation available."
    }
}

private struct Translations : Codable {
    let translations : [TranslatedText]
}

private struct TranslatedText : Codable {
    let translatedText : String
}

//
//  GoogleAPIResponse.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

struct GoogleTranslationAPIResponse: Codable {
    let data: Translations
}

struct Translations : Codable {
    let translations : [TranslatedText]
}

struct TranslatedText : Codable {
    let translatedText : String
}

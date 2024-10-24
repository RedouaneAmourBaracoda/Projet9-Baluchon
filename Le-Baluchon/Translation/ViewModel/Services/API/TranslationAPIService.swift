//
//  TranslationAPIService.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol TranslationAPIService {
    func fetchTranslation(text: String, source: String, target: String, format: String) async throws -> String
}

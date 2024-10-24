//
//  TranslationAPIService.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol TranslationAPIServiceType {
    func fetchTranslation(text: String, source: String, target: String, format: String) async throws -> String
}

final class MockTranslationAPIService: TranslationAPIServiceType {

    var textToReturn: String!

    var error: Error?

    var fetchTranslationCallsCounter = 0

    func fetchTranslation(text: String, source: String, target: String, format: String ) async throws -> String {
        fetchTranslationCallsCounter += 1

        guard let error else { return textToReturn }

        throw error
    }
}

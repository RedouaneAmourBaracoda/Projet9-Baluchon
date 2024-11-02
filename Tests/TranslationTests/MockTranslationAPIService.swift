//
//  MockTranslationAPIService.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 24/10/2024.
//

@testable import Le_Baluchon
import Foundation

final class MockTranslationAPIService: TranslationAPIService {

    var textToReturn: String!

    var error: Error?

    var fetchTranslationCallsCounter = 0

    func fetchTranslation(text: String, source: String, target: String, format: String ) async throws -> String {
        fetchTranslationCallsCounter += 1

        guard let error else { return textToReturn }

        throw error
    }
}

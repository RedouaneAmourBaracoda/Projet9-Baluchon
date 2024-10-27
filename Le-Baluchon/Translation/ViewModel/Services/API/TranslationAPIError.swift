//
//  TranslationAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 26/10/2024.
//

import Foundation

protocol TranslationAPIError: LocalizedError, CaseIterable {
    var errorDescription: String { get }

    var userFriendlyDescription: String { get }
}

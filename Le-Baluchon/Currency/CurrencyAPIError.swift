//
//  CurrencyAPIError.swift
//  Le-Baluchon
//
//  Created by Redouane on 26/10/2024.
//

import Foundation

protocol CurrencyAPIError: LocalizedError, CaseIterable {
    var errorDescription: String { get }

    var userFriendlyDescription: String { get }
}

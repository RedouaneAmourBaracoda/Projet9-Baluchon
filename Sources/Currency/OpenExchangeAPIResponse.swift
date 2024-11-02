//
//  OpenExchangeAPIResponse.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

struct OpenExchangeAPIResponse: Codable {
    let rates: [String: Double]
}

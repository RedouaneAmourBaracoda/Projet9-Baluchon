//
//  DataStoreServiceType.swift
//  Le-Baluchon
//
//  Created by Redouane on 21/10/2024.
//

import Foundation

protocol DataStoreServiceType {

    func save(_ date: TimeInterval, rates: [String : Double])

    func retrieveDate() -> (TimeInterval?)

    func retrieveRates() -> [String : Double]?
}

final class MockDataStoreService: DataStoreServiceType {

    var persistedDate: TimeInterval?

    var persistedRates: [String : Double]?

    var saveCallsCounter = 0

    var retrieveDateCallsCounter = 0

    var retrieveRatesCallsCounter = 0

    func save(_ date: TimeInterval, rates: [String : Double]) {
        saveCallsCounter += 1
        persistedDate = date
        persistedRates = rates
    }

    func retrieveDate() -> (TimeInterval)? {
        retrieveDateCallsCounter += 1
        return persistedDate
    }

    func retrieveRates() -> [String: Double]? {
        retrieveRatesCallsCounter += 1
        return persistedRates
    }
}

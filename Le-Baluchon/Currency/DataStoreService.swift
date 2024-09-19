//
//  DataStoreService.swift
//  Le-Baluchon
//
//  Created by Redouane on 18/09/2024.
//

import SwiftUI

protocol DataStoreService {

    func save(_ date: TimeInterval, rates: [String : Double])

    func retrieveDate() -> (TimeInterval?)

    func retrieveRates() -> [String : Double]?
}

final class MockDataStoreService: DataStoreService {

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

final class RealDataStoreService: DataStoreService {

    // MARK: - AppStorage.

    private enum Keys {

        static let lastUpdatedRates = "lastUpdatedRates"

        static let lastUpdateDateInSeconds = "LastDateInSeconds"
    }

    @AppStorage(Keys.lastUpdateDateInSeconds) private var persistedDate: TimeInterval?

    @AppStorage(Keys.lastUpdatedRates) private var rawPersistedRates: Data?

    // MARK: - Properties.

    private var persistedRates: [String : Double]?

    // MARK: - Methods.

    func save(_ date: TimeInterval, rates: [String : Double]) {
        persistedDate = date
        persistedRates = rates
        rawPersistedRates = try? JSONEncoder().encode(persistedRates)
    }

    func retrieveDate() -> (TimeInterval)? {
        persistedDate
    }

    func retrieveRates() -> [String: Double]? {
        guard let rawPersistedRates else { return nil }
        persistedRates = try? JSONDecoder().decode([String : Double].self, from: rawPersistedRates)
        return persistedRates
    }
}

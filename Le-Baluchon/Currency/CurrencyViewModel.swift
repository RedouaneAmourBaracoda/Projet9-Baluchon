//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import Foundation
import SwiftUI

@MainActor
final class CurrencyViewModel: ObservableObject {

    private enum Keys {
        static let lastUpdatedRates = "lastUpdatedRates"
        static let lastUpdateDateInSeconds = "LastDateInSeconds"
    }

    // MARK: - AppStorage.

    @AppStorage(Keys.lastUpdateDateInSeconds) var lastUpdateDateInSeconds: TimeInterval?

    @AppStorage(Keys.lastUpdatedRates) var lastRates: Data?

    // MARK: - State

    @Published var outputString: String?

    @Published var baseCurrency: CurrencyItem = .Euro

    @Published var convertToCurrency: CurrencyItem = .USDollar

    @Published var baseValue: Double = 1000.0

    // MARK: - Properties.

    private let maxInterval: Double = 60

    let formatter: NumberFormatter = .valueFormatter

    // MARK: - Methods.

    func fetchCurrency() async {
        guard isUpdateNeeded() else { return }

        do {
            let result = try await CurrencyApiService.shared.fetchCurrency()
            save(result)
        } catch let error as HTTPError {
            print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
        } catch {
            print(error.localizedDescription)
        }
    }

    private func isUpdateNeeded() -> Bool {
        guard let lastRates, let lastDate = lastUpdateDateInSeconds else { return true }
        return Date.now.timeIntervalSince1970 - lastDate > maxInterval
    }

    private func save(_ result: ExpectedRates) {
        lastUpdateDateInSeconds = Date.now.timeIntervalSince1970
        lastRates = try? JSONEncoder().encode(result.rates)
    }

    func swapCurrencies() {
        let initialBaseCurrency = baseCurrency
        baseCurrency = convertToCurrency
        convertToCurrency = initialBaseCurrency
    }
}

private extension NumberFormatter {
    static let valueFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        return formatter
    }()
}

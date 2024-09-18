//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

@MainActor
final class CurrencyViewModel: ObservableObject {

    private enum Keys {
        static let lastUpdatedRates = "lastUpdatedRates"
        static let lastUpdateDateInSeconds = "LastDateInSeconds"
    }

    // MARK: - AppStorage.

    @AppStorage(Keys.lastUpdateDateInSeconds) private var lastUpdateDateInSeconds: TimeInterval?

    @AppStorage(Keys.lastUpdatedRates) private var lastRates: Data?

    // MARK: - State

    @Published var outputString: String?

    @Published var baseCurrency: CurrencyItem = .Euro

    @Published var targetCurrency: CurrencyItem = .USDollar

    @Published var baseValue: Double = 1000.0

    // MARK: - Properties.

    private let maxInterval: Double = 3600

    let formatter: NumberFormatter = .valueFormatter

    // MARK: - Methods.

    func convert() async {
        if shouldUpdate() { await fetchCurrency() }

        guard
            let lastRates,
            let decodedRates = try? JSONDecoder().decode([String: Double].self, from: lastRates),
            let baseRateInUSD = decodedRates[baseCurrency.abreviation],
            let targetRateInUSD = decodedRates[targetCurrency.abreviation]
        else { return }

        outputString = formatter.string(from: NSNumber(value: baseValue * (targetRateInUSD / baseRateInUSD)))
    }
    private func fetchCurrency() async {
        do {
            let result = try await CurrencyApiService.shared.fetchCurrency()
            save(result)
        } catch let error as HTTPError {
            print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
        } catch {
            print(error.localizedDescription)
        }
    }

    private func shouldUpdate() -> Bool {
        guard let _ = lastRates, let lastDate = lastUpdateDateInSeconds else { return true }
        return Date.now.timeIntervalSince1970 - lastDate > maxInterval
    }

    private func save(_ result: ExpectedRates) {
        lastUpdateDateInSeconds = Date.now.timeIntervalSince1970
        lastRates = try? JSONEncoder().encode(result.rates)
    }

    func swapCurrencies() {
        let initialBaseCurrency = baseCurrency
        baseCurrency = targetCurrency
        targetCurrency = initialBaseCurrency
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

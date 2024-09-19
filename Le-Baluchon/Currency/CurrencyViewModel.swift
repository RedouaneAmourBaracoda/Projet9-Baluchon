//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

@MainActor
final class CurrencyViewModel: ObservableObject {

    // MARK: - State

    @Published var outputString: String?

    @Published var baseCurrency: CurrencyItem = .Euro

    @Published var targetCurrency: CurrencyItem = .USDollar

    @Published var baseValue: Double = 1000.0

    @Published var shouldPresentAlert = false

    var error: Error?

    // MARK: - Services.

    private let currencyApiService: CurrencyAPIService

    private let dataStoreService: DataStoreService

    // MARK: - Properties.

    private let maxInterval: Double = 3600

    let formatter: NumberFormatter = .valueFormatter

    // MARK: - Initializer.

    init(currencyApiService: CurrencyAPIService, dataStoreService: DataStoreService) {
        self.currencyApiService = currencyApiService
        self.dataStoreService = dataStoreService
    }

    // MARK: - Methods.

    func convert() async {

        if shouldUpdateRates() { await getCurrency() }

        guard
            let lastRates = dataStoreService.retrieveRates(),
            let baseRateInUSD = lastRates[baseCurrency.abreviation],
            let targetRateInUSD = lastRates[targetCurrency.abreviation]
        else { return }

        outputString = formatter.string(from: NSNumber(value: baseValue * (targetRateInUSD / baseRateInUSD)))
    }

    private func shouldUpdateRates() -> Bool {

        let lastRates = dataStoreService.retrieveRates()

        let lastDate = dataStoreService.retrieveDate()

        guard let _ = lastRates, let lastDate else { return true }

        return Date.now.timeIntervalSince1970 - lastDate > maxInterval
    }

    private func getCurrency() async {
        do {
            let result = try await currencyApiService.fetchCurrency()
            dataStoreService.save(Date.now.timeIntervalSince1970, rates: result.rates)
        } catch {
            self.error = error
            shouldPresentAlert = true
        }
    }

    func swapCurrencies() {
        let initialBaseCurrency = baseCurrency
        baseCurrency = targetCurrency
        targetCurrency = initialBaseCurrency
    }
}

extension CurrencyViewModel {
    func testShouldUpdateRates() -> Bool {
        self.shouldUpdateRates()
    }

    func testGetCurrency() async {
        await self.getCurrency()
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

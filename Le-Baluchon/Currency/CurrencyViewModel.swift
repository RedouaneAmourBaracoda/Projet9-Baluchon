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

    @Published var baseCurrency: CurrencyItem = .euro

    @Published var targetCurrency: CurrencyItem = .usDollar

    @Published var baseValue: Double = 1000.0

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let currencyApiService: CurrencyAPIServiceType

    private let dataStoreService: DataStoreServiceType

    private let formatter: NumberFormatter

    // MARK: - Properties.

    private let maxInterval: Double = 3600

    // MARK: - Initializer.

    init(
        currencyApiService: CurrencyAPIServiceType = OpenExchangeAPIService(),
        dataStoreService: DataStoreServiceType = UserDefaultsService(),
        formatter: NumberFormatter = .valueFormatter
    ) {
        self.currencyApiService = currencyApiService
        self.dataStoreService = dataStoreService
        self.formatter = formatter
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

    func shouldUpdateRates() -> Bool {

        let lastRates = dataStoreService.retrieveRates()

        let lastDate = dataStoreService.retrieveDate()

        guard let _ = lastRates, let lastDate else { return true }

        return Date.now.timeIntervalSince1970 - lastDate > maxInterval
    }

    func getCurrency() async {
        do {
            let rates = try await currencyApiService.fetchCurrency()
            dataStoreService.save(Date.now.timeIntervalSince1970, rates: rates)
        } catch {
            if let currencyAPIError = error as? LocalizedError {
                errorMessage = currencyAPIError.errorDescription ?? .currencyUndeterminedErrorDescription
            } else {
                errorMessage = .currencyUndeterminedErrorDescription
            }
            shouldPresentAlert = true
        }
    }

    func swapCurrencies() {
        let initialBaseCurrency = baseCurrency
        baseCurrency = targetCurrency
        targetCurrency = initialBaseCurrency
    }
}

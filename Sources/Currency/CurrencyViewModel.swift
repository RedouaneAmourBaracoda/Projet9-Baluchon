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

    @Published var inputString: String = "1000"

    @Published var outputString: String?

    @Published var baseCurrency: CurrencyItem

    @Published var targetCurrency: CurrencyItem

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services.

    private let currencyApiService: CurrencyAPIService

    private let dataStoreService: DataStoreServiceType

    private let formatter: NumberFormatter

    // MARK: - Properties.

    private let maxInterval: Double = 3600

    // MARK: - Initializer.

    init(
        currencyApiService: CurrencyAPIService = OpenExchangeAPIService(),
        dataStoreService: DataStoreServiceType = UserDefaultsService(),
        formatter: NumberFormatter = .currencyFormatter
    ) {
        let localeCurrency = CurrencyItem.allCases.first {
            $0.identifier == Locale.current.currency?.identifier
            && $0.symbol == Locale.current.currencySymbol
        } ?? .usDollar

        baseCurrency = localeCurrency

        targetCurrency = localeCurrency == .usDollar ? .euro : .usDollar

        self.currencyApiService = currencyApiService

        self.dataStoreService = dataStoreService

        self.formatter = formatter
    }

    // MARK: - Methods.

    func convert() async {

        guard !inputString.isEmpty else {
            outputString = ""
            return
        }

        guard let inputBaseNumber = formatter.number(from: inputString) else {
            errorMessage = Localizable.Currency.invalidNumberDescription
            shouldPresentAlert = true
            return
        }

        if shouldUpdateRates() { await getCurrency() }

        guard
            let lastRates = dataStoreService.retrieveRates(),
            let baseRateInUSD = lastRates[baseCurrency.identifier],
            let targetRateInUSD = lastRates[targetCurrency.identifier]
        else { return }

        let result = Double(truncating: inputBaseNumber) * (targetRateInUSD / baseRateInUSD)

        outputString = formatter.string(from: NSNumber(value: result))
    }

    func shouldUpdateRates() -> Bool {

        let lastRates = dataStoreService.retrieveRates()

        let lastDate = dataStoreService.retrieveDate()

        guard lastRates != nil, let lastDate else { return true }

        return Date.now.timeIntervalSince1970 - lastDate > maxInterval
    }

    func getCurrency() async {
        do {
            let rates = try await currencyApiService.fetchCurrency()
            dataStoreService.save(Date.now.timeIntervalSince1970, rates: rates)
        } catch {
            if let currencyAPIError = error as? (any CurrencyAPIError) {
                NSLog(currencyAPIError.errorDescription ?? Localizable.Currency.undeterminedErrorDescription)
                errorMessage = currencyAPIError.userFriendlyDescription
            } else {
                errorMessage = Localizable.Currency.undeterminedErrorDescription
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

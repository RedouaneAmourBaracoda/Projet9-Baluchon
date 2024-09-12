//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import Foundation

@MainActor
final class CurrencyViewModel: ObservableObject {
    @Published var outputString: String?
    @Published var baseCurrency: CurrencyItem = .Euro
    @Published var convertToCurrency: CurrencyItem = .USDollar
    @Published var baseValue: Double = 1000.0
    let formatter: NumberFormatter = .valueFormatter

    func fetchCurrency() async {
        do {
            let currency = try await CurrencyApiService.shared.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
            guard let safeRate = currency.data[convertToCurrency.abreviation], let safeString = format(value: baseValue * safeRate) else { return }
            outputString = safeString
        } catch let error as HTTPError {
            print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
        } catch {
            print(error.localizedDescription)
        }
    }

    func format(value: Double) -> String? {
        formatter.string(from: NSNumber(value: value))
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

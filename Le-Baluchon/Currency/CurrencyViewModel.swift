//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import Foundation

@MainActor
final class CurrencyViewModel: ObservableObject {
    @Published var outputValue: Double = 1000.0

    func fetchCurrency(baseCurrency: String, convertToCurrency: String, baseValue: Double) async {
        do {
            let currency = try await CurrencyApiService.shared.fetchCurrency(baseCurrency: baseCurrency, convertToCurrency: convertToCurrency)
            guard let safeRate = currency.data[convertToCurrency] else { return }
            outputValue = baseValue * safeRate
        } catch let error as HTTPError {
            print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
        } catch {
            print(error.localizedDescription)
        }
    }
}

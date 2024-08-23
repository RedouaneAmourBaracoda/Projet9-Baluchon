//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import Foundation

final class CurrencyViewModel: ObservableObject {
    @Published var value: Float = 1100.0
    
    func fetchCurrency(baseCurrency: String, convertToCurrency: String, baseValue: Float) {
        Task { @MainActor in
            do {
                let currency = try await CurrencyApiService.shared.fetchCurrency(baseCurrency: baseCurrency, convertToCurrency: convertToCurrency)
                guard let safeRate = currency.data[convertToCurrency] else { return }
                value = baseValue * safeRate
            } catch let error as HTTPError {
                print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

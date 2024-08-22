//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import Foundation

final class CurrencyViewModel: ObservableObject {
    func fetchCurrency() {
        Task { @MainActor in
            do {
                let currency = try await CurrencyApiService.shared.fetchCurrency()
                print(currency)
            } catch let error as HTTPError {
                print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

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
        static let lastUpdateDateInSeconds = "LastDateInSeconds"
    }

    // MARK: - Dependencies.

    @AppStorage(Keys.lastUpdateDateInSeconds) var lastUpdateDateInSeconds: TimeInterval?

    // MARK: - State
    @Published var outputString: String?

    @Published var baseCurrency: CurrencyItem = .Euro

    @Published var convertToCurrency: CurrencyItem = .USDollar

    @Published var baseValue: Double = 1000.0

    // MARK: - Properties.

    private var timer: Timer?

    private let maxInterval: Double = 60

    let formatter: NumberFormatter = .valueFormatter

    // MARK: - Methods.

    func fetchCurrency() async {
        timer?.invalidate()

        do {
            let currency = try await CurrencyApiService.shared.fetchCurrency()
            print(currency.rates)
        } catch let error as HTTPError {
            print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
        } catch {
            print(error.localizedDescription)
        }
    }

    func swapCurrencies() {
        let initialBaseCurrency = baseCurrency
        baseCurrency = convertToCurrency
        convertToCurrency = initialBaseCurrency
    }

    private func saveDate() {
        let timeIntervalInSeconds = Date.now.timeIntervalSince1970
        UserDefaults.standard.set(timeIntervalInSeconds, forKey: "LastDateInSeconds")
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

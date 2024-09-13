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

    // MARK: - Dependencies
    @AppStorage("LastDateInSeconds") var lastDateInSeconds: TimeInterval?

    // MARK: - State
    @Published var outputString: String?

    @Published var baseCurrency: CurrencyItem = .Euro

    @Published var convertToCurrency: CurrencyItem = .USDollar

    @Published var baseValue: Double = 1000.0

    // MARK: - Properties

    private var timer: Timer?

    private let maxInterval: Double = 60

    let formatter: NumberFormatter = .valueFormatter

    func fetchCurrency() async {
        timer?.invalidate()

        do {
            let currency = try await CurrencyApiService.shared.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
            guard let safeRate = currency.data[convertToCurrency.abreviation], let safeString = formatter.string(from: NSNumber(value: baseValue * safeRate)) else { return }
            outputString = safeString
            saveDate()
        } catch let error as HTTPError {
            print(error.errorDescription ?? "An HTTP error occured but cannot be determined.")
        } catch {
            print(error.localizedDescription)
        }

        launchTimer(initialTime: 0)
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

    func updateCurrencyIfNeeded() {
        let lastUpdateInSeconds = lastDateInSeconds ?? maxInterval
        let timeInterval = Date.now.timeIntervalSince1970 - lastUpdateInSeconds

        if timeInterval > maxInterval {
            Task {
                await fetchCurrency()
            }
        } else {
            launchTimer(initialTime: timeInterval)
        }
    }

    func launchTimer(initialTime: Double) {
        var timeInterval = initialTime

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in

            timeInterval += 1

            if timeInterval > self.maxInterval {
                Task {
                    await self.fetchCurrency()
                }
            }
        }
        timer?.fire()
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

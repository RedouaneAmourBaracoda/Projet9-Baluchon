//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject private var currencyViewModel = CurrencyViewModel()
    @State private var baseCurrency: CurrencyItem = .Euro
    @State private var convertToCurrency: CurrencyItem = .USDollar
    @State private var baseValue: Double = 1000.0
    private let formatter: NumberFormatter = .valueFormatter

    var body: some View {
        VStack {
            baseCurrencyView()
            Image(systemName: "arrowshape.down")
            conversionCurrencyView()
            convertActionView()
        }
    }

    private func baseCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $baseCurrency) {
            TextField("", value: $baseValue, formatter: formatter)
                .keyboardType(.decimalPad)
                .valueStyle()

        }
    }

    private func conversionCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $convertToCurrency) {
            if let value = formatter.string(from: NSNumber(value: currencyViewModel.outputValue)) {
                Text(value)
                    .valueStyle()
            }
        }
    }

    private func convertActionView() -> some View {
        Button(action: {
            Task {
                await currencyViewModel.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation, baseValue: baseValue)
            }
        }, label: {
            Text("Convert")
                .font(.title)
        })
        .buttonStyle(.bordered)
    }
}

private extension View {
    func valueStyle() -> some View {
        modifier(ValueModifier())
    }
}

private struct ValueModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.black)
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

#Preview {
    CurrencyView()
}

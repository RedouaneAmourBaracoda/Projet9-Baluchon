//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject private var currencyViewModel = CurrencyViewModel()
    @State private var baseCurrency: Currencies = .Euro
    @State private var convertToCurrency: Currencies = .USDollar
    @State private var baseValue: Float = 1000.0

    var body: some View {
        VStack {
            DropDownView(selectedCurrency: $baseCurrency, value: $baseValue)
            DropDownView(selectedCurrency: $convertToCurrency, value: $currencyViewModel.value)
            Spacer()
            Button(action: {
                currencyViewModel.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation, baseValue: baseValue)
            }, label: {
                Text("Fetch currency")
            })
        }
    }
}

#Preview {
    CurrencyView()
}

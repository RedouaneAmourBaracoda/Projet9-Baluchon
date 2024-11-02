//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject private var currencyViewModel = CurrencyViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    baseCurrencyView()

                    swapActionView()

                    targetCurrencyView()
                }
            }
            .refresh(currencyViewModel: currencyViewModel)
            .alert(isPresented: $currencyViewModel.shouldPresentAlert) {
                Alert(title: Text(Localizable.errorAlertTitle), message: Text(currencyViewModel.errorMessage))
            }
            .navigationTitle(Localizable.Currency.navigationTitle)
        }
    }

    private func baseCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.baseCurrency) {
            TextField(
                Localizable.Currency.textFieldPlaceHolder,
                text: $currencyViewModel.inputString,
                axis: .horizontal
            )
            .keyboardType(.decimalPad)
            .valueStyle(fontWeight: .light)
            .onSubmit {
                Task {
                    await currencyViewModel.convert()
                }
            }
        }
    }

    private func swapActionView() -> some View {
        Button(action: {
            currencyViewModel.swapCurrencies()
        }, label: {
            Image(uiImage: .init(resource: .init(name: "swap", bundle: .main)))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
        })
    }

    private func targetCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.targetCurrency) {
            Text(currencyViewModel.outputString ?? Localizable.Currency.noData)
                .valueStyle(fontWeight: .light)
                .lineLimit(1)
        }
    }
}

#Preview {
    CurrencyView()
}

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
        VStack {
            baseCurrencyView()
            swapActionView()
            conversionCurrencyView()
            convertActionView()
        }
        .onAppear {
            Task {
                await currencyViewModel.fetchCurrency()
            }
        }
    }

    private func baseCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.baseCurrency) {
            TextField("", value: $currencyViewModel.baseValue, formatter: currencyViewModel.formatter)
                .keyboardType(.decimalPad)
                .valueStyle(fontWeight: .bold)

        }
    }

    private func conversionCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.convertToCurrency) {
            Text(currencyViewModel.outputString ?? "" )
                    .valueStyle(fontWeight: .light)
        }
    }

    private func convertActionView() -> some View {
        Button(action: {
            Task {
                await currencyViewModel.fetchCurrency()
            }
        }, label: {
            Text("Convert")
                .font(.title)
        })
        .buttonStyle(.bordered)
    }

    private func swapActionView() -> some View {
        Button(action: {
            currencyViewModel.swapCurrencies()
        }, label: {
            Image(uiImage: .init(resource: .init(name: "swap", bundle: .main)))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
              .padding()
        })
    }
}

private extension View {
    func valueStyle(fontWeight: Font.Weight) -> some View {
        modifier(ValueModifier(fontWeight: fontWeight))
    }
}

private struct ValueModifier: ViewModifier {
    let fontWeight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(fontWeight)
            .foregroundStyle(Color.black)
    }
}

#Preview {
    CurrencyView()
}

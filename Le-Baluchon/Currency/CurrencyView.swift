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
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    baseCurrencyView()
                    swapActionView()
                    targetCurrencyView()
                    Spacer()
                    pullToRefreshView()
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .refresh(currencyViewModel: currencyViewModel)
            .safeAreaPadding(.vertical)
        }
        .alert(isPresented: $currencyViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(currencyViewModel.errorMessage))
        }
    }

    private func baseCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.baseCurrency) {
            TextField("", value: $currencyViewModel.baseValue, formatter: NumberFormatter.valueFormatter)
                .keyboardType(.decimalPad)
                .valueStyle(fontWeight: .bold)

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
              .padding()
        })
    }

    private func targetCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.targetCurrency) {
            Text(currencyViewModel.outputString ?? "" )
                    .valueStyle(fontWeight: .light)
        }
    }

    private func pullToRefreshView() -> some View {
        Image(uiImage: UIImage(resource: .init(name: "pull-to-refresh", bundle: .main)))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 150, maxHeight: 150)
            .opacity(0.1)
    }
}

#Preview {
    CurrencyView()
}

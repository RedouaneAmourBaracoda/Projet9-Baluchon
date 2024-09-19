//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject private var currencyViewModel = CurrencyViewModel(
        currencyApiService: RealCurrencyApiService.shared,
        dataStoreService: RealDataStoreService()
    )

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    baseCurrencyView()
                    swapActionView()
                    targetCurrencyView()
                    Spacer()
                    pullToRefreshView()

                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .refresh(currencyViewModel: currencyViewModel)
        }
        .alert(isPresented: $currencyViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(currencyViewModel.error?.localizedDescription ?? "Internal error occured and cannot be determined."))
        }
    }

    private func baseCurrencyView() -> some View {
        CurrencyItemView(selectedCurrency: $currencyViewModel.baseCurrency) {
            TextField("", value: $currencyViewModel.baseValue, formatter: currencyViewModel.formatter)
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
        Image(uiImage: UIImage(resource: .init(name: "pull-to-refresh", bundle: .main))).opacity(0.1)
    }
}

#Preview {
    CurrencyView()
}

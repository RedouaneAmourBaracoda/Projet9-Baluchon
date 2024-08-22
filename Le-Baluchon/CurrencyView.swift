//
//  ContentView.swift
//  Baluchon
//
//  Created by Redouane on 08/08/2024.
//

import SwiftUI

struct CurrencyView: View {
    let currencyViewModel = CurrencyViewModel()

    var body: some View {
        VStack {
            HStack {
                // Utiliser le navigation link pour le picker
            }
            Button(action: {
                currencyViewModel.fetchCurrency()
            }, label: {
                Text("Fetch currency")
            })
        }
    }
}

#Preview {
    CurrencyView()
}

//
//  CurrenciesDropDownView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/08/2024.
//

import SwiftUI

struct CurrencyItemView<Value: View>: View {

    @Binding private var selectedCurrency: CurrencyItem

    private let value: Value

    init(selectedCurrency: Binding<CurrencyItem>, @ViewBuilder value: () -> Value) {
        self._selectedCurrency = selectedCurrency
        self.value = value()
    }

    var body: some View {
        HStack {
            selectableCurrencyView()
                .fixedSize()
            Spacer()
            Text(selectedCurrency.symbol)
            value
                .padding(.trailing)
        }
        .background { Color.gray.opacity(0.3) }
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding()
    }

    private func selectableCurrencyView() -> some View {
        HStack(spacing: 0) {
            resizableImageView()
            dropDownView()
        }
    }

    private func resizableImageView() -> some View {
        Image(uiImage: UIImage(resource: .init(name: selectedCurrency.flag, bundle: .main)))
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, height: 50)
          .padding()
    }

    private func dropDownView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Menu(selectedCurrency.identifier) {
                    ForEach(CurrencyItem.allCases, id: \.self) { currency in
                        Button(action: {
                            selectedCurrency = currency
                        }, label: {
                            Text(currency.identifier)
                        })
                    }
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)

                Image(systemName: "chevron.down")
            }

            Text(selectedCurrency.rawValue)
                .font(.subheadline)
                .foregroundStyle(Color.gray)
        }
    }
}

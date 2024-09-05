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
            Spacer()
            valueView()
        }
        .withBackground()
    }

    private func selectableCurrencyView() -> some View {
        HStack(spacing: 0) {
            resizableImageView()
            dropDownView()
        }
    }

    private func resizableImageView() -> some View {
        Image(uiImage: selectedCurrency.flag)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, height: 50)
          .padding()
    }

    private func dropDownView() -> some View {
        VStack(alignment: .leading){
            HStack {
                Menu(selectedCurrency.abreviation) {
                    ForEach(CurrencyItem.allCases, id: \.self) { currency in
                        Button(action: {
                            selectedCurrency = currency
                        }, label: {
                            Text(currency.abreviation)
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

    private func valueView() -> some View {
        HStack {
            Text(selectedCurrency.symbol)
            value
                .fixedSize()
                .padding(.trailing)
        }
    }
}

private extension View {
    func withBackground(color: Color = .gray.opacity(0.3)) -> some View {
        modifier(BackgroundModifier(color: color))
    }
}

private struct BackgroundModifier: ViewModifier {
    private let color: Color

    init(color: Color) {
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .background { color }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding()
    }
}

//
//  CurrencyViewModifiers.swift
//  Le-Baluchon
//
//  Created by Redouane on 18/09/2024.
//

import SwiftUI

extension View {
    func valueStyle(fontWeight: Font.Weight) -> some View {
        modifier(ValueModifier(fontWeight: fontWeight))
    }

    func refresh(currencyViewModel: CurrencyViewModel) -> some View {
        modifier(RefreshableModifier(currencyViewModel: currencyViewModel))
    }
}

private struct ValueModifier: ViewModifier {
    private let fontWeight: Font.Weight

    init(fontWeight: Font.Weight) {
        self.fontWeight = fontWeight
    }

    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(fontWeight)
            .foregroundStyle(Color.black)
    }
}

private struct RefreshableModifier: ViewModifier {
    @ObservedObject private var currencyViewModel: CurrencyViewModel

    init(currencyViewModel: CurrencyViewModel) {
        self.currencyViewModel = currencyViewModel
    }

    func body(content: Content) -> some View {
        content
            .refreshable {
                await currencyViewModel.convert()
            }
            .task { await currencyViewModel.convert() }
            .task(id: currencyViewModel.baseCurrency) { await currencyViewModel.convert() }
            .task(id: currencyViewModel.targetCurrency) { await currencyViewModel.convert() }
            .task(id: currencyViewModel.baseValue) { await currencyViewModel.convert() }
    }
}

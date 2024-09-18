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

struct ValueModifier: ViewModifier {
    let fontWeight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(fontWeight)
            .foregroundStyle(Color.black)
    }
}

struct RefreshableModifier: ViewModifier {
    @ObservedObject private var currencyViewModel: CurrencyViewModel

    init(currencyViewModel: CurrencyViewModel) {
        self.currencyViewModel = currencyViewModel
    }

    func body(content: Content) -> some View {
        content
            .refreshable {
                await currencyViewModel.convert()
            }
            .onChange(of: currencyViewModel.baseCurrency) {
                Task {
                    await currencyViewModel.convert()
                }
            }
            .onChange(of: currencyViewModel.convertToCurrency) {
                Task {
                    await currencyViewModel.convert()
                }
            }
            .onChange(of: currencyViewModel.baseValue) {
                Task {
                    await currencyViewModel.convert()
                }
            }
            .onAppear {
                Task {
                    await currencyViewModel.convert()
                }
            }
    }
}

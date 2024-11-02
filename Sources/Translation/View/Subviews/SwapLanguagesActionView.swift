//
//  SwapLanguagesActionView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct SwapLanguagesActionView: View {

    @ObservedObject private var translationViewModel: TranslationViewModel

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        Button(action: {
            translationViewModel.swapLanguages()
        }, label: {
            Image(systemName: "arrow.triangle.swap")
                .rotationEffect(.degrees(90))
        })
        .disabled(translationViewModel.baseLanguageItem == .autoDetection)
    }
}

#Preview {
    SwapLanguagesActionView(translationViewModel: .init())
}

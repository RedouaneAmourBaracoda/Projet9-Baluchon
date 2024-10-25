//
//  SwiftUIView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/09/2024.
//

import SwiftUI

struct TranslationView: View {
    @ObservedObject private var translationViewModel = TranslationViewModel()

    var body: some View {
        ViewThatFits(in: .vertical) {
            verticalLayoutView()
            horizontalLayoutView()
        }
        .alert(isPresented: $translationViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(translationViewModel.errorMessage))
        }
    }

    private func verticalLayoutView() -> some View {
        VStack {
            LanguageSelectionView(translationViewModel: translationViewModel, useVerticalLayout: true)

            InputTextView(translationViewModel: translationViewModel)

            OutputTextView(translationViewModel: translationViewModel)

            Spacer()
        }
    }

    private func horizontalLayoutView() -> some View {
        HStack {
            LanguageSelectionView(translationViewModel: translationViewModel, useVerticalLayout: false)
            VStack {
                InputTextView(translationViewModel: translationViewModel)
                OutputTextView(translationViewModel: translationViewModel)
            }
        }
    }
}

#Preview {
    TranslationView()
}

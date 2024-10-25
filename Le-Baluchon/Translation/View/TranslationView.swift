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
        NavigationStack {
            ViewThatFits(in: .vertical) {
                verticalLayoutView()
                horizontalLayoutView()
            }
            .alert(isPresented: $translationViewModel.shouldPresentAlert) {
                Alert(title: Text("Error"), message: Text(translationViewModel.errorMessage))
            }
            .navigationTitle("Translation")
        }
    }

    private func verticalLayoutView() -> some View {
        VStack {
            HStack {
                BaseLanguageSelectionView(translationViewModel: translationViewModel)

                SwapLanguagesActionView(translationViewModel: translationViewModel)

                TargetLanguageSelectionView(translationViewModel: translationViewModel)
            }

            InputTextView(translationViewModel: translationViewModel)

            OutputTextView(translationViewModel: translationViewModel)

            Spacer()
        }
    }

    private func horizontalLayoutView() -> some View {
        HStack {
            VStack {
                BaseLanguageSelectionView(translationViewModel: translationViewModel)

                SwapLanguagesActionView(translationViewModel: translationViewModel)

                TargetLanguageSelectionView(translationViewModel: translationViewModel)
            }

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

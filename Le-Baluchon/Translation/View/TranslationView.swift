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
            .ignoresSafeArea(.keyboard)
            .alert(isPresented: $translationViewModel.shouldPresentAlert) {
                Alert(title: Text(Localizable.errorAlertTitle), message: Text(translationViewModel.errorMessage))
            }
            .navigationTitle(Localizable.Translation.navigationTitle)
        }
    }

    private func verticalLayoutView() -> some View {
        ScrollView { // ScrollView is necessary to avoid keyboard push up.
            HStack {

                BaseLanguageSelectionView(translationViewModel: translationViewModel)

                SwapLanguagesActionView(translationViewModel: translationViewModel)

                TargetLanguageSelectionView(translationViewModel: translationViewModel)
            }

            InputTextView(translationViewModel: translationViewModel)

            OutputTextView(translationViewModel: translationViewModel)
        }
    }

    private func horizontalLayoutView() -> some View {
        ScrollView { // ScrollView is necessary to avoid keyboard push up.
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
}

#Preview {
    TranslationView()
}

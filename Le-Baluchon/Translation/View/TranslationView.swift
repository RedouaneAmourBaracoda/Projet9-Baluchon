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
            portraitView()
            landscapeView()
        }
        .alert(isPresented: $translationViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(translationViewModel.errorMessage))
        }
    }

    private func portraitView() -> some View {
        VStack {
            LanguageSelectionView(translationViewModel: translationViewModel)

            InputTextView(translationViewModel: translationViewModel)

            OutputTextView(translationViewModel: translationViewModel)

            Spacer()
        }
    }

    private func landscapeView() -> some View {
        HStack {
            LanguageSelectionView(translationViewModel: translationViewModel)
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

//
//  BaseLanguageSelectionView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct BaseLanguageSelectionView: View {

    @ObservedObject private var translationViewModel: TranslationViewModel

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        LanguageMenuView(selectedLanguage: $translationViewModel.baseLanguageItem, languages: LanguageItem.allCases)
            .padding()
            .withBackground()
            .onChange(of: translationViewModel.baseLanguageItem) { translationViewModel.clear() }
    }
}

#Preview {
    BaseLanguageSelectionView(translationViewModel: .init())
}

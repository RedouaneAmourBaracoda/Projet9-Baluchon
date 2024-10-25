//
//  TargetLanguageSelectionView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct TargetLanguageSelectionView: View {

    @ObservedObject private var translationViewModel: TranslationViewModel

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        LanguageMenuView(
            selectedLanguage: $translationViewModel.targetLanguageItem,
            languages: LanguageItem.allCases.filter({ $0 != .autoDetection })
        )
        .padding()
        .withBackground()
        .onChange(of: translationViewModel.targetLanguageItem) { translationViewModel.clear() }
    }
}

#Preview {
    TargetLanguageSelectionView(translationViewModel: .init())
}

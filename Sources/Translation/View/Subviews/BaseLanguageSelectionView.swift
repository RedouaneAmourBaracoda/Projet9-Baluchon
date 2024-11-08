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
            .onChange(of: translationViewModel.baseLanguageItem) { _ in translationViewModel.clear() }
            .background { Color.gray.opacity(0.3) }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding()
    }
}

#Preview {
    BaseLanguageSelectionView(translationViewModel: .init())
}

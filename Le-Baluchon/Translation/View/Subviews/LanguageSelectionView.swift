//
//  DropDownView.swift
//  Le-Baluchon
//
//  Created by Redouane on 24/10/2024.
//

import SwiftUI

struct LanguageSelectionView: View {
    @ObservedObject private var translationViewModel: TranslationViewModel

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        ViewThatFits {
            portraitOrientationView()
            landscapeOrientationView()
        }
        .onChange(of: translationViewModel.baseLanguageItem) { translationViewModel.clear() }
        .onChange(of: translationViewModel.targetLanguageItem) { translationViewModel.clear() }
    }

    private func portraitOrientationView() -> some View {
        HStack {
            baseLanguageSelectionView()
            swapLanguagesActionView()
            targetLanguageSelectionView()
        }
    }

    private func landscapeOrientationView() -> some View {
        VStack {
            baseLanguageSelectionView()
            swapLanguagesActionView()
            targetLanguageSelectionView()
        }
    }

    private func baseLanguageSelectionView() -> some View {
        dropDownView(selectedItem: $translationViewModel.baseLanguageItem, languages: LanguageItem.allCases)
            .padding()
            .withBackground()
    }

    private func swapLanguagesActionView() -> some View {
        Button(action: {
            translationViewModel.swapLanguages()
        }, label: {
            Image(systemName: "arrow.triangle.swap")
                .rotationEffect(.degrees(90))
        })
        .disabled(translationViewModel.baseLanguageItem == .autoDetection)
    }

    private func targetLanguageSelectionView() -> some View {
        dropDownView(
            selectedItem: $translationViewModel.targetLanguageItem,
            languages: LanguageItem.allCases.filter({ $0 != .autoDetection })
        )
        .padding()
        .withBackground()
    }

    private func dropDownView(selectedItem: Binding<LanguageItem>, languages: [LanguageItem]) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Menu(selectedItem.wrappedValue.rawValue) {
                    ForEach(languages, id: \.self) { languageItem in
                        Button(action: {
                            selectedItem.wrappedValue = languageItem
                        }, label: {
                            Text(languageItem.rawValue)
                        })
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.black)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    LanguageSelectionView(translationViewModel: .init())
}
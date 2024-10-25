//
//  LanguageMenuView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct LanguageMenuView: View {
    @Binding private var selectedLanguage: LanguageItem

    private let languages: [LanguageItem]

    init(selectedLanguage: Binding<LanguageItem>, languages: [LanguageItem]) {
        self._selectedLanguage = selectedLanguage
        self.languages = languages
    }
    var body: some View {
        HStack {
            Menu(selectedLanguage.rawValue) {
                ForEach(languages, id: \.self) { languageItem in
                    Button(action: {
                        selectedLanguage = languageItem
                    }, label: {
                        Text(languageItem.rawValue)
                    })
                }
            }
            .font(.subheadline)
            .foregroundStyle(Color.black)
            .padding(.horizontal)
        }
        .padding()
    }
}

struct LanguageMenuView_Previews: PreviewProvider {
    struct LanguageMenuViewContainer: View {
        @State private var selectedLanguage: LanguageItem = .english

        var body: some View {
            LanguageMenuView(selectedLanguage: $selectedLanguage, languages: LanguageItem.allCases)
        }
    }

    static var previews: some View {
        LanguageMenuViewContainer()
    }
}

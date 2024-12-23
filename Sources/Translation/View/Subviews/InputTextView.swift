//
//  InputTextView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct InputTextView: View {
    @ObservedObject private var translationViewModel: TranslationViewModel

    @FocusState private var showKeyboard: Bool

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(translationViewModel.baseLanguageItem.rawValue)
                .font(.subheadline)
                .foregroundStyle(Color.black)

            TextField(
                translationViewModel.baseLanguageItem.greetings,
                text: $translationViewModel.inputText,
                axis: .vertical
            )
            .lineLimit(1, reservesSpace: true)
            .fontWeight(.ultraLight)
            .keyboardType(.alphabet)
            .focused($showKeyboard)
            .autocorrectionDisabled()
            .toolbar {
                if showKeyboard {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: {
                            showKeyboard = false
                            Task {
                                await translationViewModel.translate()
                            }
                        }, label: {
                            Text(Localizable.Translation.toolbarTranslateButtonTitle)
                        })
                    }
                }
            }
        }
        .padding()
        .background { Color.gray.opacity(0.3) }
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding()
    }
}

#Preview {
    InputTextView(translationViewModel: .init())
}

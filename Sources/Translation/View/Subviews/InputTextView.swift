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
            .keyboardType(.emailAddress)
            .focused($showKeyboard)
            .autocorrectionDisabled()
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(action: {
                        showKeyboard = false
                        Task {
                            await translationViewModel.translate()
                        }
                    }, label: {
                        Text(Localizable.Currency.toolbarDoneButtonTitle)
                    })
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

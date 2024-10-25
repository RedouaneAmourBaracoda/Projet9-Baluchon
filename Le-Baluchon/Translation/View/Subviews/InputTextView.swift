//
//  InputTextView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct InputTextView: View {
    @ObservedObject private var translationViewModel: TranslationViewModel

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(translationViewModel.baseLanguageItem.rawValue)
                .font(.subheadline)
                .foregroundStyle(Color.black)

            TextField(
                translationViewModel.baseLanguageItem.defaultWord,
                text: $translationViewModel.inputText,
                axis: .vertical
            )
            .lineLimit(1, reservesSpace: true)
            .fontWeight(.ultraLight)
            .autocorrectionDisabled()
            .onSubmit {
                Task {
                    await translationViewModel.translate()
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

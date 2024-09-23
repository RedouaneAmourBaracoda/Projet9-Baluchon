//
//  SwiftUIView.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/09/2024.
//

import SwiftUI

struct TranslationView: View {

    @ObservedObject private var translationViewModel = TranslationViewModel(translationAPIService: RealTranslationAPIService.shared)

    var body: some View {
        VStack {
            HStack {
                Text(translationViewModel.baseLanguageItem.rawValue)
                    .padding()
                    .withBackground()

                Image(systemName: "arrow.triangle.swap")
                    .rotationEffect(.degrees(90))

                Text(translationViewModel.targetLanguageItem.rawValue)
                    .padding()
                    .withBackground()
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(translationViewModel.baseLanguageItem.rawValue)

                TextField("Type text", text: $translationViewModel.inputText, axis: .vertical)
                    .lineLimit(7, reservesSpace: true)
                    .fontWeight(.thin)
                    .onSubmit {
                        Task {
                            await translationViewModel.translate()
                        }
                    }
            }
            .padding()
            .withBackground()

            VStack(alignment: .leading, spacing: 0) {
                Text(translationViewModel.targetLanguageItem.rawValue)
                Text(translationViewModel.outputText)
                    .lineLimit(7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.thin)
            }
            .padding()
            .withBackground()

            Spacer()
        }
    }
}

#Preview {
    TranslationView()
}

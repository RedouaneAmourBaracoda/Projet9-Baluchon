//
//  OutputTextView.swift
//  Le-Baluchon
//
//  Created by Redouane on 25/10/2024.
//

import SwiftUI

struct OutputTextView: View {
    @ObservedObject private var translationViewModel: TranslationViewModel

    @State private var scrollViewContentSize: CGSize?

    init(translationViewModel: TranslationViewModel) {
        self.translationViewModel = translationViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(translationViewModel.targetLanguageItem.rawValue)
                .font(.subheadline)
                .foregroundStyle(Color.black)
                .padding([.horizontal, .top])

            ScrollView {
                Text(translationViewModel.outputText.isEmpty ?
                     translationViewModel.targetLanguageItem.defaultWord
                     : translationViewModel.outputText
                )
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                scrollViewContentSize = geometry.size
                            }
                    }
                }
            }
            .frame(maxHeight: scrollViewContentSize?.height)
            .fontWeight(.ultraLight)
            .opacity(translationViewModel.outputText.isEmpty ? 0.25 : 1.0)
            .padding([.horizontal, .bottom])

            Divider()

            Button {
                translationViewModel.clear()
            } label: {
                Text("Clear")
            }
            .padding()

        }
        .background { Color.gray.opacity(0.3) }
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding()
    }
}

#Preview {
    OutputTextView(translationViewModel: .init())
}

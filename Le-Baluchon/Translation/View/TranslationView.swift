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
                dropDownView(selectedItem: $translationViewModel.baseLanguageItem)
                    .padding()
                    .withBackground()

                Button(action: {
                    translationViewModel.swapLanguages()
                }, label: {
                    Image(systemName: "arrow.triangle.swap")
                        .rotationEffect(.degrees(90))
                })

                dropDownView(selectedItem: $translationViewModel.targetLanguageItem)
                    .padding()
                    .withBackground()
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(translationViewModel.baseLanguageItem.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(Color.black)

                TextField(
                    translationViewModel.baseLanguageItem.defaultWord,
                    text: $translationViewModel.inputText,
                    axis: .vertical
                )
                .lineLimit(5, reservesSpace: true)
                .fontWeight(.ultraLight)

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
                    .font(.subheadline)
                    .foregroundStyle(Color.black)
                    .padding([.horizontal, .top])

                Text(translationViewModel.outputText.isEmpty ?
                     translationViewModel.targetLanguageItem.defaultWord
                     : translationViewModel.outputText
                )
                .lineLimit(5)
                .frame(maxWidth: .infinity, alignment: .leading)
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
            .withBackground()

            Spacer()
        }
    }

    private func dropDownView(selectedItem: Binding<LanguageItem>) -> some View {
        VStack(alignment: .leading){
            HStack {
                Menu(selectedItem.wrappedValue.rawValue) {
                    ForEach(LanguageItem.allCases, id: \.self) { languageItem in
                        Button(action: {
                            selectedItem.wrappedValue = languageItem
                        }, label: {
                            Text(languageItem.rawValue)
                        })
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.black)
            }
        }
    }
}

#Preview {
    TranslationView()
}

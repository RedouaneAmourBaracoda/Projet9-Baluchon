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

            selectableLanguagesView()

            inputTranslationView()

            outputTranslationView()

            Spacer()
        }
        .alert(isPresented: $translationViewModel.shouldPresentAlert) {
            Alert(title: Text("Error"), message: Text(translationViewModel.errorMessage), dismissButton: .default(Text("Understood"), action: {
                translationViewModel.clear()
            }))
        }
    }

    private func selectableLanguagesView() -> some View {
        HStack {
            dropDownView(selectedItem: $translationViewModel.baseLanguageItem, languages: LanguageItem.allCases)
                .padding()
                .withBackground()

            Button(action: {
                translationViewModel.swapLanguages()
            }, label: {
                Image(systemName: "arrow.triangle.swap")
                    .rotationEffect(.degrees(90))
            })

            dropDownView(selectedItem: $translationViewModel.targetLanguageItem, languages: LanguageItem.allCases.filter({ $0 != .autoDetection }))
                .padding()
                .withBackground()
        }
        .onChange(of: translationViewModel.baseLanguageItem) { translationViewModel.clear() }
        .onChange(of: translationViewModel.targetLanguageItem) { translationViewModel.clear() }
    }

    private func dropDownView(selectedItem: Binding<LanguageItem>, languages: [LanguageItem]) -> some View {
        VStack(alignment: .leading){
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
            }
        }
    }

    private func inputTranslationView() -> some View {
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
    }

    private func outputTranslationView() -> some View {
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
    }
}

#Preview {
    TranslationView()
}

//
//  BackgroundModifier.swift
//  Le-Baluchon
//
//  Created by Redouane on 23/09/2024.
//

import SwiftUI

extension View {
    func withBackground(color: Color = .gray.opacity(0.3)) -> some View {
        modifier(BackgroundModifier(color: color))
    }
}

private struct BackgroundModifier: ViewModifier {
    private let color: Color

    init(color: Color) {
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .background { color }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding()
    }
}

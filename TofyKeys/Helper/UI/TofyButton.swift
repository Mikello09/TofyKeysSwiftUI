//
//  TofyButton.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import SwiftUI



// MARK: PRINCIPAL BUTTON
struct PrincipalButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? Color.whiteHighlighted : Color.white)
            .background(configuration.isPressed ? Color.primaryColorHighlighted : Color.primaryColor)
            .cornerRadius(8)
    }
}

let PrincipalButtonText: (LocalizedStringKey) -> Text = { text in
    Text(text)
        .font(Font.system(size: 18, weight: .semibold))
}


// MARK: SECONDARY BUTTON
struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? .primaryColorHighlighted : .primaryColor)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(configuration.isPressed ? Color.primaryColorHighlighted : Color.primaryColor, lineWidth: 1))
    }
}

let SecondaryButtonText: (LocalizedStringKey) -> Text = { text in
    Text(text)
        .font(Font.system(size: 18, weight: .semibold))
}


func TextButton(text: LocalizedStringKey, foregroundColor: Color = .primaryColor, size: CGFloat = 18) -> some View {
    return Text(text)
        .foregroundColor(foregroundColor)
        .font(.system(size: size, weight: .bold, design: .default))
}


func imageButton(systemName: String, color: Color, size: CGFloat = 20) -> some View {
        Image(systemName: systemName)
            .resizable()
            .tint(color)
            .frame(width: size, height: size)
            .font(.system(size: size, weight: .semibold))
            .padding()
}

// MARK: HIGHLIGHT BUTTON
struct HighlightButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 12)
            .padding()
            .foregroundColor(configuration.isPressed ? Color.whiteHighlighted : Color.white)
            .background(configuration.isPressed ? Color.primaryColorHighlighted : Color.primaryColor)
            .cornerRadius(12)
    }
}


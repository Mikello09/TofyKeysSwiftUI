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


func textButton(text: LocalizedStringKey) -> some View {
    return Text(text)
        .foregroundColor(.primaryColor)
        .font(.system(size: 18, weight: .bold, design: .default))
}


func imageButton(systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .resizable()
            .tint(color)
            .frame(width: 20, height: 20)
            .font(.system(size: 20, weight: .semibold))
            .padding()
}


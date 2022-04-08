//
//  TofyButton.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import SwiftUI


func textButton(text: String) -> some View {
    return Text(text)
        .foregroundColor(.primaryColor)
        .font(.system(size: 18, weight: .bold, design: .default))
}

func imageButton(systemName: String, color: Color) -> some View {
    return Image(systemName: systemName)
        .resizable()
        .tint(color)
}

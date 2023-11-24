//
//  TofyTextField.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 18/4/22.
//

import Foundation
import SwiftUI

struct LoginTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.blackTofy, lineWidth: 1))
            .foregroundColor(Color.blackTofy)
            .font(Font.system(size: 17, weight: .regular))
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
        
    }
    
}

struct LabelField: TextFieldStyle {
    
    var textSize: CGFloat = 17
    var textWeight: Font.Weight = .regular
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .font(Font.system(size: textSize, weight: textWeight))
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 2)
            }
    }
    
}

struct TofyTextField: View {
    
    @Binding var text: String
    var title: String
    
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                if isEditing {
                    HStack {
                        Text(title)
                            .font(Font.system(size: 11))
                            .foregroundStyle(Color.secondaryColor)
                        Spacer()
                    }
                }
                TextField(title, text: $text) { _ in
                    withAnimation {
                        isEditing.toggle()
                    }
                }
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.primaryText)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
    }
    
}

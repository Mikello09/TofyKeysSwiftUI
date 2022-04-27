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
                            .stroke(Color.gray, lineWidth: 1))
            .font(Font.system(size: 17, weight: .regular))
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
        
    }
    
    
}

extension TextField {
    
    func loginTextField() -> some View{
        self.padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(height: 56)
    }
    
}

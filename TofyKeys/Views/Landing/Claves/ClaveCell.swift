//
//  ClaveCell.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 10/6/22.
//

import SwiftUI

struct ClaveCell: View {
    
    @State var clave: Clave
    @State var isUpdated: Bool
    
    @State var backgroundColor: Color = .claveCellColor
    @State var borderColor: Color = .clear
    @State var borderWidth: CGFloat = 0
    
    var animationFinished: (() -> ())
    
    var body: some View {
        HStack {
            Text(clave.titulo).title(.white)
                .padding(.leading)
            Spacer()
        }
        .frame(height: 64)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: borderWidth))
        .shadow(color: .selectedClaveCells, radius: 2, x: 2, y: 2)
        .simultaneousGesture(
            TapGesture()
                .onEnded({ _ in
                    SelectedAnimation(colorToChange: $backgroundColor).animate(from: .claveCellColor,
                                                                               to: .selectedClaveCells)
                })
        )
        .onAppear() {
            if isUpdated {
                print("clave \(clave.titulo)")
                withAnimation(.linear(duration: 0.5)) {
                    borderColor = .selectedClaveCells
                    borderWidth = 3
                }
                withAnimation(.linear(duration: 0.3).delay(0.5)) {
                    borderColor = .claveCellColor
                    borderWidth = 0
                }
                animationFinished()
            }
        }
    }
}

//struct ClaveCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ClaveCell(clave: Clave())
//    }
//}

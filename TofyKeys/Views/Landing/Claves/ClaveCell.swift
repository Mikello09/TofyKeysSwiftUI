//
//  ClaveCell.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 10/6/22.
//

import SwiftUI

struct ClaveCell: View {
    
    @State var clave: Clave
    
    @State var backgroundColor: Color = .claveCellColor
    
    var body: some View {
        HStack {
            Text(clave.titulo).title(.white)
                .padding(.leading)
            Spacer()
        }
        .frame(height: 64)
        .background(backgroundColor)
        .cornerRadius(8)
        .shadow(color: .selectedClaveCells, radius: 2, x: 2, y: 2)
        .simultaneousGesture(
            TapGesture()
                .onEnded({ _ in
                    SelectedAnimation(colorToChange: $backgroundColor).animate(from: .claveCellColor,
                                                                               to: .selectedClaveCells)
                })
        )
        
    }
}

struct ClaveCell_Previews: PreviewProvider {
    static var previews: some View {
        ClaveCell(clave: Clave())
    }
}

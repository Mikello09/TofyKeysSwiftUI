//
//  ClaveCell.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 10/6/22.
//

import SwiftUI

struct ClaveCell: View {
    
    @State var clave: Clave
    
    var body: some View {
        HStack {
            Text(clave.titulo).title()
                .padding(.leading)
            Spacer()
        }
        .frame(height: 48)
        .background(.white)
        .cornerRadius(8)
        
    }
}

struct ClaveCell_Previews: PreviewProvider {
    static var previews: some View {
        ClaveCell(clave: Clave())
    }
}

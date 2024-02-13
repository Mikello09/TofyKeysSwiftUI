//
//  CuentaView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 9/2/24.
//

import SwiftUI

struct CuentaView: View {
    
    var cuenta: Producto
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack {
                Spacer()
                Text(cuenta.titulo)
                    .font(Font.system(size: 20, weight: .bold))
                    .padding([.leading, .trailing], 24)
                Spacer()
            }
            HStack {
                Spacer()
                Text(cuenta.getIngresosGastosDifference().toCurrency())
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.secondaryColor)
                    .padding([.leading, .trailing], 24)
                Spacer()
            }
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}


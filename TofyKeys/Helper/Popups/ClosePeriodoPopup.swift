//
//  ClosePeriodoPopup.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 22/8/23.
//

import SwiftUI

struct ClosePeriodoPopup: View {
    
    var completion: (() -> Void)
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Spacer()
                VStack(spacing: 24) {
                    HStack {
                        Spacer()
                        Text("Vas a cerrar el periodo")
                        Spacer()
                    }
                    Button("SI") {
                        completion()
                    }
                }
                .padding()
                .frame(height: 250)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                Spacer()
            }
        }
    }
}

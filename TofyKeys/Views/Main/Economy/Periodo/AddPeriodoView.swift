//
//  AddPeriodoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 25/6/23.
//

import Foundation
import SwiftUI

struct AddPeriodoView: View {
    
    @State var titulo: String = ""
    @State var tipo: String = "manual"
    
    var onAdd: ((String, String) -> Void)
    
    var body: some View {
        
        VStack(spacing: 24) {
            ZStack {
                Text("Add Periodo")
                HStack {
                    Spacer()
                    Button (action: {
                        if !titulo.isEmpty {
                            onAdd(titulo, tipo)
                        }
                    }, label: {
                        TextButton(text: "Guardar")
                    })
                    .padding()
                }
            }
            TextField("Título", text: $titulo)
            Picker(selection: $tipo, label: Text("Forma de creación")) {
                Text("Manual").tag("manual")
                Text("Automático").tag("automatico")
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                if tipo == "manual" {
                    Text("Termina el periodo cuando tú quieras.")
                } else {
                    Text("El periodo finalizará el primer día del siguiente mes")
                }
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        
    }
    
}

//
//  AddTransferPeriodoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 29/6/23.
//

import SwiftUI

struct AddTransferPeriodoView: View {
    
    @State var titulo: String = ""
    @State var tipo: String = "gasto"
    @State var valor: String = ""
    
    var onAdd: (String, String, Double) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Text("Gasto o Ingreso")
                HStack {
                    Spacer()
                    Button (action: {
                        if !titulo.isEmpty && !valor.isEmpty {
                            onAdd(titulo, tipo, (valor as NSString).doubleValue)
                        }
                    }, label: {
                        TextButton(text: "Guardar")
                    })
                    .padding()
                }
            }
            TextField("Título", text: $titulo)
            Picker(selection: $tipo, label: Text("¿Que es lo que quieres añadir?")) {
                Text("Gasto").tag("gasto")
                Text("Ingreso").tag("ingreso")
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("Valor", text: $valor)
                .keyboardType(.numberPad)
            Spacer()
        }
        .padding()
    }
}

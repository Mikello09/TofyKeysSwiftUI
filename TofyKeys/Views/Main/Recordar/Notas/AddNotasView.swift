//
//  AddNotasView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 28/5/23.
//

import SwiftUI

struct Nota: Hashable, Identifiable {
    var id: UUID
    var tokenUsuario: String
    var titulo: String
    var nota: String
    var fecha: String
    var actualizado: Bool
    var isFavourite: Bool
    
    func toClave() -> Clave {
        return Clave(id: id.uuidString,
                     tokenUsuario: tokenUsuario,
                     titulo: titulo,
                     valores: Valores(tipo: ClaveType.lista.rawValue, valor: nota),
                     fecha: fecha,
                     actualizado: actualizado,
                     isFavourite: isFavourite)
    }
}

struct AddNotasView: View {
    
    @State var title: String = ""
    @State var nota: String = ""
    
    var onAdd: ((String, String) -> Void)
    
    var body: some View {
        VStack {
            ZStack {
                Text(LocalizedStringKey("NewNota"))
                    .title(.black)
                    .padding()
                HStack {
                    Spacer()
                    Button (action: {
                        onAdd(title, nota)
                    }, label: {
                        TextButton(text: LocalizedStringKey("Save"))
                    })
                    .padding(.trailing)
                }
            }
            TextField(LocalizedStringKey("NotaTitle"), text: $title)
                .font(Font.system(size: 20, weight: .bold))
                .frame(height: 48)
                .padding()
            TextField(LocalizedStringKey("NotaMessage"), text: $nota, axis: .vertical)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            Spacer()
        }
    }
}

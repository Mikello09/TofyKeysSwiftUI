//
//  ShowNotaView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 28/5/23.
//

import SwiftUI

enum ShowNotaState {
    case view
    case editing
}

struct ShowNotaView: View {
    
    var nota: Nota
    @State var state: ShowNotaState = .view
    @State var newTitle: String = ""
    @State var newNota: String = ""
    var onEdit: ((Nota, String, String) -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button (action: {
                    switch state {
                    case .view: state = .editing
                    case .editing: onEdit(nota, newTitle, newNota)
                    }
                }, label: {
                    TextButton(text: state == .view ? LocalizedStringKey("Edit") : LocalizedStringKey("Save"))
                })
                .padding()
            }
            switch state {
            case .view:
                ScrollView() {
                    Text(nota.titulo)
                        .font(Font.system(size: 20, weight: .bold))
                        .padding()
                    Text(nota.nota)
                        .font(Font.system(size: 17, weight: .regular))
                        .padding()
                    Spacer()
                }
            case .editing:
                TextField(LocalizedStringKey("NotaTitle"), text: $newTitle)
                    .font(Font.system(size: 20, weight: .bold))
                    .frame(height: 48)
                    .padding()
                    .background(Color.gray)
                TextField(LocalizedStringKey("NotaMessage"), text: $newNota, axis: .vertical)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding()
                    .background(Color.gray)
                Spacer()
            }
        }
        .onAppear {
            newTitle = nota.titulo
            newNota = nota.nota
        }
    }
}

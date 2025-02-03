//
//  LienzoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 25/11/24.
//

import SwiftUI

struct LienzoView: View {
    @Environment(\.modelContext) private var modelContext
    
    var tipo: TipoClave
    
    @State var titulo: String = ""
    
    // Clave
    @State var claveItems: [ClaveItem] = []
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField(tipo.title(), text: $titulo)
                        .font(Font.system(size: 22, weight: .semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Button {
                        switch tipo {
                        case .clave:
                            print(claveItems)
                            let newClave = Clave(id: UUID(), titulo: titulo, creationDate: Date(), lastModified: Date(), items: claveItems)
                            modelContext.insert(newClave)
                        case .nota: ()
                        case .list: ()
                        }
                    } label: {
                        Text("Guardar")
                    }
                    .padding()
                }
                
                switch tipo {
                case .clave:
                    ClaveView(values: $claveItems)
                case .nota:
                    EmptyView()
                case .list:
                    EmptyView()
                }
            }
        }
    }
}



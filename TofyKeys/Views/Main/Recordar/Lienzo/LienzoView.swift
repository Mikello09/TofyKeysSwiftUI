//
//  LienzoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 25/11/24.
//

import SwiftUI

struct LienzoView: View {
    
    @State var claveTitulo: String = ""
    
    @State var showingItems: [ClaveItem] = []
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Nueva clave", text: $claveTitulo)
                        .font(Font.system(size: 22, weight: .semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Button {
                        print(showingItems)
                    } label: {
                        Text("Guardar")
                    }
                    .padding()
                }
                
                VStack {
                    ScrollView {
                        ForEach($showingItems, id: \.id) { $item in
                            ClaveItemView(clave: $item) { claveToDelete in
                                showingItems.removeAll(where: { $0.id == claveToDelete.id })
                            }
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    Spacer()
                    LienzoToolbar() { selectedItem in
                        showingItems.append(ClaveItem(tipo: selectedItem))
                    }
                }
                .padding()
            }
        }
    }
}

struct LienzoToolbar: View {
    
    var onSelect: (TipoClave) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(TipoClave.allCases, id: \.self) { tipo in
                Button {
                    onSelect(tipo)
                } label: {
                    tipo.icon()
                        .frame(width: 32, height: 32)
                        .background(RoundedRectangle(cornerRadius: 4).fill(.gray).shadow(radius: 1))
                }
            }
        }
        .padding()
        .border(.black)
    }
}

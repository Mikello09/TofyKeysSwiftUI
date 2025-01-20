//
//  RecordarView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 1/5/23.
//

import Foundation
import SwiftUI

struct RecordarView: View {
    
    @ObservedObject var viewModel: RecordarViewModel
    
    @State var lastItems: [Clave] = []
    @State var allItems: [Clave] = []
    
    @State var addClave: Bool = false
    
    var body: some View {
        TofyNavigation {
            ZStack {
                if allItems.isEmpty {
                    Text("Start adding items to remember")
                } else {
                    VStack {
                        ScrollView(.vertical) {
                            VStack {
                                Text("Últimos añadidos")
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(lastItems, id: \.id) { item in
                                            Text(item.titulo)
                                        }
                                    }
                                }
                            }
                            VStack {
                                Text("Todos")
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(allItems, id: \.id) { item in
                                            Text(item.titulo)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            addClave = true
                        } label: {
                            Image(systemName: "plus")
                                .background(Circle().fill(.blue).frame(width: 48, height: 48))
                                .padding()
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $addClave) {
                    LienzoView()
                }
            }
            .navigationTitle("Para recordar")
        }
    }
    
}



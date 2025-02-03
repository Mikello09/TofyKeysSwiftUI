//
//  RecordarView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 1/5/23.
//

import Foundation
import SwiftUI
import SwiftData

struct RecordarView: View {
    // BBDD
    @Environment(\.modelContext) private var modelContext
    @Query private var claves: [Clave]
    
    @ObservedObject var viewModel: RecordarViewModel
    
    @State var addClave: Bool = false
    
    var body: some View {
        TofyNavigation {
            ZStack {
                if claves.isEmpty {
                    Text("Start adding items to remember")
                } else {
                    VStack {
                        ScrollView(.vertical) {
                            VStack {
                                Text("Últimos añadidos")
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(claves, id: \.id) { item in
                                            Text(item.titulo)
                                        }
                                    }
                                }
                            }
                            VStack {
                                Text("Todos")
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(claves, id: \.id) { item in
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
                        NavigationLink {
                            ClaveSelectionView()
                        } label: {
                            Image(systemName: "plus")
                                .background(Circle().fill(.blue).frame(width: 48, height: 48))
                                .padding()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Para recordar")
        }
    }
    
}



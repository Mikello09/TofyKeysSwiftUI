//
//  NotasView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 28/5/23.
//

import SwiftUI

struct NotasView: View {
    
    @ObservedObject var claveViewModel: ClaveViewModel
    
    @State var showAddNotas: Bool = false
    @State var notas: [Nota] = []
    @State var selectedNota: Nota? = nil
    
    var body: some View {
        TofyNavigation {
            ZStack {
                if notas.isEmpty {
                    VStack {
                        Spacer()
                        LottieView(name: "add", loopMode: .loop)
                            .frame(width: 64, height: 64)
                            .onTapGesture {
                                self.showAddNotas = true
                            }
                        Text(LocalizedStringKey("EmptyNotas"))
                            .title()
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 64)
                        Spacer()
                    }
                } else {
                    ScrollView() {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                            ForEach(notas, id: \.self) { nota in
                                NotaCell(nota: nota)
                                    .frame(width: 150, height: 150)
                                    .padding()
                                    .simultaneousGesture(
                                        TapGesture().onEnded({ _ in
                                            self.selectedNota = nota
                                        })
                                    )
                                    .contextMenu {
                                        Button {
                                            claveViewModel.setFavourite(clave: nota.toClave())
                                        } label: {
                                            HStack {
                                                Text("Favourite")
                                                Spacer()
                                                Image(systemName: "heart.fill")
                                            }
                                        }
                                        Button {
                                            claveViewModel.deleteClave(clave: nota.toClave())
                                        } label: {
                                            HStack {
                                                Text("Delete")
                                                Spacer()
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("Notas"))
            .toolbar(content: {
                Button (action: {
                    self.showAddNotas = true
                }, label: {
                    imageButton(systemName: "plus.circle", color: .primaryColor, size: 24)
                })
            })
            .background(Image("tofy_background"))
        }
        .sheet(isPresented: $showAddNotas) {
            AddNotasView() { titulo, nota in
                self.showAddNotas = false
                claveViewModel.addClave(titulo: titulo, valores: Valores(tipo: ClaveType.lista.rawValue,
                                                                         valor: nota))
            }
        }
        .sheet(item: $selectedNota, content: { nota in
            ShowNotaView(nota: nota, onEdit: onEdited)
        })
        .onReceive(claveViewModel.$notas) { notas in
            self.notas = notas
        }
    }
    
    func onEdited(nota: Nota, newTitle: String, newNota: String) {
        self.selectedNota = nil
        var claveToEdit = nota.toClave()
        claveToEdit.titulo = newTitle
        claveToEdit.valores = Valores(tipo: ClaveType.lista.rawValue, valor: newNota)
        claveViewModel.updateClave(clave: claveToEdit)
    }
}

struct NotaCell: View {
    
    var nota: Nota
    
    var body: some View {
        ZStack {
            if nota.isFavourite {
                VStack {
                    HStack{
                        Spacer()
                        Image(systemName: "heart.fill")
                            .padding()
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(nota.titulo)
                        .font(Font.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            }
        }
        .background(Color.primaryColor)
        .cornerRadius(8)
    }
}

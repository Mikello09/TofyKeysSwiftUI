//
//  ShowClaveView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 13/6/22.
//

import SwiftUI

struct ShowClaveView: View {
    
    @Binding var clave: Clave
    
    @State var isEditing: Bool = false
    @State var title: String = ""
    @State var valor: String = ""
    @State var usuario: String = ""
    @State var contrasena: String = ""
    
    var onDelete: (_: Clave) -> Void
    var onEdit: (_: Clave) -> Void
    
    var body: some View {
        ZStack {
            if isEditing {
                VStack {
                    TextField(LocalizedStringKey("Title"), text: $title)
                        .textFieldStyle(LoginTextFieldStyle())
                    if clave.valor != "" {
                        TextField(LocalizedStringKey("Value"), text: $valor)
                            .textFieldStyle(LoginTextFieldStyle())
                    } else {
                        TextField(LocalizedStringKey("User"), text: $usuario)
                            .textFieldStyle(LoginTextFieldStyle())
                        TextField(LocalizedStringKey("Password"), text: $contrasena)
                            .textFieldStyle(LoginTextFieldStyle())
                    }
                    Button {
                        onEdit(Clave(token: clave.token,
                                     tokenUsuario: clave.tokenUsuario,
                                     titulo: title,
                                     valor: valor,
                                     usuario: usuario,
                                     contrasena: contrasena,
                                     fecha: Date().toString(),
                                     actualizado: false))
                    } label: {
                        PrincipalButtonText("edit")
                    }
                    Spacer()
                }
            } else {
                VStack(spacing: 24) {
                    HStack {
                        Button {
                            onDelete(clave)
                        } label: {
                            textButton(text: "delete", foregroundColor: .redTofy)
                        }
                        Spacer()
                        Button {
                            isEditing = true
                        } label: {
                            textButton(text: "edit", foregroundColor: .blue)
                        }
                    }
                    HStack {
                        Spacer()
                        Text(clave.titulo).title()
                        Spacer()
                    }
                    .padding()
                    Divider()
                        .background(.gray)
                    if clave.valor != "" { // VALOR
                        ZStack {
                            HStack {
                                Text(clave.valor).subtitle()
                                Spacer(minLength: 48)
                            }
                            HStack {
                                Spacer()
                                Button {
                                    print("Copy value")
                                } label: {
                                    imageButton(systemName: "doc.on.doc.fill", color: .gray)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                    } else { // USUARIO & CONTRASEÑA
                        ZStack {
                            HStack {
                                Text(clave.usuario).subtitle()
                                Spacer(minLength: 48)
                            }
                            HStack {
                                Spacer()
                                Button {
                                    print("Copy value")
                                } label: {
                                    imageButton(systemName: "doc.on.doc.fill", color: .gray)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        ZStack {
                            HStack {
                                Text(clave.contrasena).subtitle()
                                Spacer(minLength: 48)
                            }
                            HStack {
                                Spacer()
                                Button {
                                    print("Copy value")
                                } label: {
                                    imageButton(systemName: "doc.on.doc.fill", color: .gray)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .onChange(of: clave, perform: { claveToShow in
            isEditing = false
            title = claveToShow.titulo
            valor = claveToShow.valor
            usuario = claveToShow.usuario
            contrasena = claveToShow.contrasena
        })
    }
}

struct ShowClaveView_Previews: PreviewProvider {
    static var previews: some View {
        ShowClaveView(clave: .constant(Clave()),
                      onDelete: {_ in },
                      onEdit: {_ in})
    }
}

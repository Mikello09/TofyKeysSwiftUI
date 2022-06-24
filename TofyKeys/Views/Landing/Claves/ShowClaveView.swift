//
//  ShowClaveView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 13/6/22.
//

import SwiftUI

struct ShowClaveView: View {
    
    @Binding var clave: Clave
    
    var body: some View {
        VStack(spacing: 24) {
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

struct ShowClaveView_Previews: PreviewProvider {
    static var previews: some View {
        ShowClaveView(clave: .constant(Clave(token: "",
                                   tokenUsuario: "",
                                   titulo: "asdf",
                                   valor: "",
                                   usuario: "asdfasdfadsfasdfasdasdfa aasdfasfasdfasdfasdasdfasdfsda asdf asdfs",
                                   contrasena: "asdfasdasd",
                                   fecha: "")))
    }
}

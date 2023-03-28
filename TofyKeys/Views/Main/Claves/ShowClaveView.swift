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
    @State var valores: Valores?
    
    var onDelete: (_: Clave) -> Void
    var onUpdate: (_: Clave) -> Void
    
    var body: some View {
        VStack {
            Text(clave.titulo).title()
                .padding()
            switch clave.valores?.getClaveType() {
            case .clave:
                Text(clave.valores?.valor ?? "")
            case .userPass:
                if let usuario = clave.valores?.valor.split(separator: VALUE_SEPARATOR).first {
                    Text(usuario)
                }
                if let pass = clave.valores?.valor.split(separator: VALUE_SEPARATOR).last {
                    Text(pass)
                }
            case .foto: EmptyView()
            case .texto: EmptyView()
            case .aparcamiento: EmptyView()
            case .lista: EmptyView()
            default: EmptyView()
            }
        }
        .onChange(of: clave, perform: { claveToShow in
            isEditing = false
            title = claveToShow.titulo
        })
    }
}

struct ShowClaveView_Previews: PreviewProvider {
    static var previews: some View {
        ShowClaveView(clave: .constant(Clave()),
                      onDelete: {_ in },
                      onUpdate: {_ in})
    }
}

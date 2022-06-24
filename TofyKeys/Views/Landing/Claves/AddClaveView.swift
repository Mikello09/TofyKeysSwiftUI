//
//  AddClaveVire.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 8/6/22.
//

import SwiftUI

struct AddClaveView: View {
    
    @Binding var claveType: ClaveType
    @State var titulo: String = ""
    @State var valor: String = ""
    @State var usuario: String = ""
    @State var contrasena: String = ""
    
    @Binding var emptyValues: Bool
    
    var onAddClave: (_ titulo: String, _ valor: String, _ usuario: String, _ contrasena: String) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(LocalizedStringKey("Add_new_key")).title()
            TextField(LocalizedStringKey("Title"), text: $titulo)
                .textFieldStyle(LoginTextFieldStyle())
            Picker(selection: $claveType, label: Text("")) {
                Text(ClaveType.value.getTitle()).tag(ClaveType.value)
                Text(ClaveType.userPass.getTitle()).tag(ClaveType.userPass)
            }.labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing])
            switch claveType {
            case .value:
                TextField(LocalizedStringKey("Value"), text: $valor)
                    .textFieldStyle(LoginTextFieldStyle())
            case .userPass:
                TextField(LocalizedStringKey("User"), text: $usuario)
                    .textFieldStyle(LoginTextFieldStyle())
                TextField(LocalizedStringKey("Password"), text: $contrasena)
                    .textFieldStyle(LoginTextFieldStyle())
            }
            if emptyValues {
                HStack {
                    Text(LocalizedStringKey("EmptyValuesAddingKey")).errorMessage()
                    Spacer()
                }.padding([.leading, .trailing])
            }
            Button {
                onAddClave(titulo, valor, usuario, contrasena)
            } label: {
                PrincipalButtonText(LocalizedStringKey("Add_key"))
            }.buttonStyle(PrincipalButton())
            Spacer()
        }
    }
}

struct AddClaveView_Previews: PreviewProvider {
    static var previews: some View {
        AddClaveView(claveType: .constant(.value), emptyValues: .constant(false), onAddClave: {_ , _ , _ , _ in
            ()
        })
    }
}

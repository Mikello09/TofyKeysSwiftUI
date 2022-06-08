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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                Button {
                    ()
                } label: {
                    PrincipalButtonText(LocalizedStringKey("Add_key"))
                }.buttonStyle(PrincipalButton())
                Spacer()
            }
        }
    }
}

struct AddClaveView_Previews: PreviewProvider {
    static var previews: some View {
        AddClaveView(claveType: .constant(.value))
    }
}

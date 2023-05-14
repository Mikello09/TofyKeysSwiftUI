//
//  AddClaveVire.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 8/6/22.
//

import SwiftUI

struct ClaveSelection: Hashable, Identifiable {
    var id: UUID = UUID()
    var type: ClaveType
    var isSelected: Bool = false
}

struct AddClaveView: View {
    
    @State var valores: [Valores] = []
    
    @Binding var selectedClaveType: ClaveType
    @State var tituloValue: String = ""
    // CLAVE
    @State var claveValue: String = ""
    // USER PASS
    @State var userValue: String = ""
    @State var passValue: String = ""
    
    @Binding var emptyValues: Bool
    
    var onAddClave: (_ title: String, _ valores: Valores) -> Void
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("Add_new_key")).title()
                .padding([.top], 24)
            TextField("Titulo", text: $tituloValue)
                .textFieldStyle(LoginTextFieldStyle())
            HStack(spacing: 8) {
                OptionSelectorView(clave: .clave, isSelected: selectedClaveType == .clave) {
                    selectedClaveType = .clave
                }
                OptionSelectorView(clave: .userPass, isSelected: selectedClaveType == .userPass) {
                    selectedClaveType = .userPass
                }
            }
            .padding()
            switch selectedClaveType {
            case .clave:
                AddClaveTypeView(claveValue: $claveValue)
            case .userPass:
                AddUserPassTypeView(userValue: $userValue, passValue: $passValue)
            default: EmptyView()
            }
            if emptyValues {
                HStack {
                    Text(LocalizedStringKey("EmptyValuesAddingKey")).errorMessage()
                    Spacer()
                }.padding([.leading, .trailing])
            }
            Button {
                prepareValuesToAdd()
            } label: {
                PrincipalButtonText(LocalizedStringKey("Add_key"))
            }.buttonStyle(PrincipalButton())
            Spacer()
        }
        .background(Color.elementColor)
    }
    
    func prepareValuesToAdd() {
        switch selectedClaveType {
        case .clave: onAddClave(tituloValue, Valores(tipo: ClaveType.clave.rawValue,
                                                     valor: claveValue))
        case .userPass: onAddClave(tituloValue, Valores(tipo: ClaveType.userPass.rawValue,
                                                        valor: "\(userValue)\(VALUE_SEPARATOR)\(passValue)"))
        case .lista: ()
        case .aparcamiento: ()
        case .foto: ()
        case .texto: ()
        }
        
    }
}

struct OptionSelectorView: View {
    
    var clave: ClaveType
    var isSelected: Bool
    var onSelect: (() -> Void)
    
    var body: some View {
        VStack(spacing: 8) {
            clave.getImage().foregroundColor(isSelected ? Color.white : Color.blackTofy)
            Text(clave.getTitle())
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? Color.white : Color.blackTofy)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.primaryColor : Color.primaryColorHighlighted)
        .shadow(color: isSelected ? .clear : .gray, radius: 5)
        .cornerRadius(8)
        .padding()
        .onTapGesture {
            onSelect()
        }
    }
    
}

// MARK: CLAVE VIEW
struct AddClaveTypeView: View {
    @Binding var claveValue: String
    var body: some View {
        TextField("Clave", text: $claveValue)
            .textFieldStyle(LoginTextFieldStyle())
    }
}
// MARK: USER PASS VIEW
struct AddUserPassTypeView: View {
    @Binding var userValue: String
    @Binding var passValue: String
    var body: some View {
        TextField("Email o nombre de usuario", text: $userValue)
            .textFieldStyle(LoginTextFieldStyle())
        TextField("Contraseña", text: $passValue)
            .textFieldStyle(LoginTextFieldStyle())
    }
}

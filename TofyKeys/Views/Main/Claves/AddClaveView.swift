//
//  AddClaveVire.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 8/6/22.
//

import SwiftUI

struct ClaveSelection: Hashable {
    var type: ClaveType
    var isSelected: Bool = false
}

struct AddClaveView: View {
    
    @State var valores: [Valores] = []
    @State var claveTypes: [ClaveSelection] = [ClaveSelection(type: .clave),
                                               ClaveSelection(type: .userPass),
                                               ClaveSelection(type: .lista),
                                               ClaveSelection(type: .aparcamiento),
                                               ClaveSelection(type: .texto),
                                               ClaveSelection(type: .foto)]
    @Binding var selectedClaveType: ClaveType
    @State var tituloValue: String = ""
    @State var claveValue: String = ""
    @State var userValue: String = ""
    @State var passValue: String = ""
    
    @Binding var emptyValues: Bool
    
    var onAddClave: (_ title: String, _ valores: Valores) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(LocalizedStringKey("Add_new_key")).title()
                .padding([.top], 24)
            TextField("Titulo", text: $tituloValue)
                .textFieldStyle(LoginTextFieldStyle())
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(claveTypes, id: \.self) { clave in
                    ClaveSelectionView(clave: clave) { claveSelected in
                        self.claveSelected(selectedClave: claveSelected)
                    }
                }
            }
            if let selectedClave = claveTypes.first(where: {$0.isSelected}) {
                switch selectedClave.type {
                case .clave: AddClaveTypeView(claveValue: $claveValue)
                case .userPass: AddUserPassTypeView(userValue: $userValue, passValue: $passValue)
                case .aparcamiento: EmptyView()
                case .foto: EmptyView()
                case .lista: EmptyView()
                case .texto: EmptyView()
                }
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
        .padding([.leading, .trailing], 12)
    }
    
    func claveSelected(selectedClave: ClaveSelection) {
        let newClaves = claveTypes.map { c in
            var clave = c
            clave.isSelected = clave.type == selectedClave.type
            return clave
        }
        selectedClaveType = selectedClave.type
        claveTypes = newClaves
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
// MARK: CLAVE SELECTION
struct ClaveSelectionView: View {
    
    @State var clave: ClaveSelection
    
    var completion: ((_ : ClaveSelection) -> Void)
    
    var body: some View {
        VStack {
            Text(clave.type.getTitle())
        }
        .frame(width: 120, height: 50)
        .border(clave.isSelected ? Color.primaryColor : Color.clear, width: 2)
        .background(clave.isSelected ? Color.primaryColor.opacity(0.5) : Color.clear)
        .cornerRadius(4)
        .onTapGesture {
            completion(ClaveSelection(type: clave.type, isSelected: !clave.isSelected))
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

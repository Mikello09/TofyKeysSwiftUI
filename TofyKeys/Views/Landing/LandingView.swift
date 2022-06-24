//
//  LandingView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct LandingView: View {
    
    // ViewModels
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var claveViewModel: ClaveViewModel
    
    // ACTION VARS
    @State var showUserSettings: Bool = false
    @State var showCreateKey: Bool = false
    @State var showClave: Bool = false
    
    // MAIN VARS
    @State var user: User?
    @State var claves: [Clave] = []
    
    // ADD CLAVE VARS
    @State var claveType: ClaveType = .value
    @State var emptyClaveValues: Bool = false
    
    // SHOW CLAVE VARS
    @State var selectedClave: Clave = Clave(token: "", tokenUsuario: "", titulo: "AAAA", valor: "", usuario: "", contrasena: "", fecha: "")
    
    var body: some View {
        ZStack {
            VStack {
                LandingTopView(showUserSettings: $showUserSettings, user: $user)
                    .frame(height: 60)
                ForEach(claves) { clave in
                    ClaveCell(clave: clave)
                        .padding([.top, .bottom], 4)
                        .onTapGesture {
                            self.claveType = clave.valor.isEmpty ? .userPass : .value
                            self.selectedClave = clave
                            self.showClave = true
                        }
                }.padding([.leading, .trailing], 24)
                Spacer()
                Button (action: {
                    showCreateKey = true
                }, label: {
                    PrincipalButtonText(LocalizedStringKey("Add_new_key"))
                }).buttonStyle(PrincipalButton())
            }
            if showCreateKey || showClave {
                DismissView()
                    .onTapGesture {
                        showCreateKey = false
                        showClave = false
                    }
            }
            ZStack {
                BottomSheetView(isOpen: $showCreateKey, maxHeight: 550, claveType: $claveType) {
                    AddClaveView(claveType: $claveType, emptyValues: $emptyClaveValues, onAddClave: onAddClave)
                }.edgesIgnoringSafeArea(.all)
                BottomSheetView(isOpen: $showClave, maxHeight: 550, claveType: $claveType) {
                    ShowClaveView(clave: $selectedClave)
                }.edgesIgnoringSafeArea(.all)
            }
        }
        .background(.blue)
        .fullScreenCover(isPresented: $showUserSettings){
            UserSettingsView().environmentObject(userViewModel)
        }
        // MARK: USER
        .onReceive(userViewModel.$user) { user in
            self.user = user
        }
        // MARK: CLAVES
        .onReceive(claveViewModel.$emptyClaveValues) { isEmptyClavesValue in
            emptyClaveValues = isEmptyClavesValue
        }
        .onReceive(claveViewModel.$claves) { claves in
            self.claves = claves
        }
        .onReceive(claveViewModel.$claveSavingState) { claveState in
            switch claveState {
            case .none: ()
            case .saving: ()
            case .locallySaved: clearBottomSheets()
            case .serverSaved: ()
            case .errorSavingToServer: ()
            }
        }
    }
}

// MARK: CLAVE FUNCTIONS
extension LandingView {
    func onAddClave(titulo: String, valor: String, usuario: String, contrasena: String) {
        self.claveViewModel.addClave(titulo: titulo, valor: valor, usuario: usuario, contrasena: contrasena)
    }
    
    func clearBottomSheets() {
        showCreateKey = false
    }
}

//struct LandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingView()
//    }
//}

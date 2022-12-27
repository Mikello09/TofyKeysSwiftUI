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
    @State var selectedClave: Clave = Clave()
    
    var body: some View {
        ZStack {
            VStack {
                LandingTopView(showUserSettings: $showUserSettings, user: $user)
                    .frame(height: 60)
                ScrollView {
                    ForEach(claves, id: \.titulo) { clave in
                        ClaveCell(clave: clave)
                            .padding([.top, .bottom], 4)
                            .simultaneousGesture(
                                TapGesture().onEnded({ _ in
                                    claveType = clave.valor.isEmpty ? .userPass : .value
                                    selectedClave = clave
                                    showClave = true
                                })
                            )
                    }.padding([.leading, .trailing], 24)
                }
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
                        clearBottomSheets()
                    }
            }
            ZStack {
                BottomSheetView(isOpen: $showCreateKey, maxHeight: 550, claveType: $claveType, onClose: clearBottomSheets) {
                    AddClaveView(claveType: $claveType, emptyValues: $emptyClaveValues, onAddClave: onAddClave)
                }.edgesIgnoringSafeArea(.all)
                BottomSheetView(isOpen: $showClave, maxHeight: 550, claveType: $claveType, onClose: clearBottomSheets) {
                    ShowClaveView(clave: $selectedClave, onDelete: onDeleteClave, onEdit: onEditClave)
                }.edgesIgnoringSafeArea(.all)
            }
        }
        .background(
            Image("tofy_background"))
        .fullScreenCover(isPresented: $showUserSettings) {
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
            withAnimation(.linear(duration: 0.2)) {
                self.claves = claves
            }
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
        claveViewModel.addClave(titulo: titulo, valor: valor, usuario: usuario, contrasena: contrasena)
    }
    
    func onDeleteClave(clave: Clave) {
        clearBottomSheets()
        claveViewModel.deleteClave(clave: clave)
    }
    
    func onEditClave(clave: Clave) {
        clearBottomSheets()
        claveViewModel.editClave(clave: clave)
    }
    
    func clearBottomSheets() {
        showCreateKey = false
        showClave = false
        selectedClave = Clave()
    }
}

//struct LandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingView()
//    }
//}

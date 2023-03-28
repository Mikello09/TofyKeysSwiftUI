//
//  LandingView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct ClavesLandingView: View {
    
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
    @State var claveType: ClaveType = .clave
    @State var emptyClaveValues: Bool = false
    
    // SHOW CLAVE VARS
    @State var selectedClave: Clave = Clave()
    @State var updatedClave: Clave = Clave()
    
    // SEARCH VALUES
    @State var searchText: String = ""
    var searchResults: [Clave] {
        if searchText.isEmpty {
            return claves
        } else {
            return claves.filter { $0.titulo.contains(searchText) }
        }
    }
    
    var body: some View {
        TofyNavigation {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(searchResults, id: \.self) { clave in
                            ClaveCell(clave: clave,
                                      isUpdated: clave.id == updatedClave.id,
                                      animationFinished: removeUpdatedClave)
                                .padding([.top, .bottom], 4)
                                .simultaneousGesture(
                                    TapGesture().onEnded({ _ in
                                        claveType = .clave
                                        selectedClave = clave
                                        showClave = true
                                    })
                                )
                        }.padding([.leading, .trailing], 24)
                    }
                    Spacer()
                }
                if showCreateKey || showClave {
                    DismissView()
                        .onTapGesture {
                            clearBottomSheets()
                        }
                }
                ZStack {
                    BottomSheetView(isOpen: $showCreateKey, maxHeight: 650, claveType: $claveType, onClose: clearBottomSheets) {
                        AddClaveView(selectedClaveType: $claveType, emptyValues: $emptyClaveValues, onAddClave: onAddClave)
                    }.edgesIgnoringSafeArea(.all)
                    BottomSheetView(isOpen: $showClave, maxHeight: 550, claveType: $claveType, onClose: clearBottomSheets) {
                        ShowClaveView(clave: $selectedClave, onDelete: onDeleteClave, onUpdate: onUpdateClave)
                    }.edgesIgnoringSafeArea(.all)
                }
            }
            .navigationTitle("Claves")
            .toolbar(content: {
                Button (action: {
                    showCreateKey = true
                }, label: {
                    imageButton(systemName: "plus.circle", color: .primaryColor, size: 24)
                })
            })
            .toolbar(content: {
                Menu(CLAVE_ORDER_TYPE.rawValue) {
                    Button(ClaveOrderType.AZ.rawValue, action: azSelection)
                    Button(ClaveOrderType.ZA.rawValue, action: zaSelection)
                    Button(ClaveOrderType.newFirst.rawValue, action: newFirstSelection)
                    Button(ClaveOrderType.oldFirst.rawValue, action: oldFirstselection)
                }

            })
            .background(
                Image("tofy_background"))
            .fullScreenCover(isPresented: $showUserSettings) {
                UserSettingsView().environmentObject(userViewModel)
            }
        }
        .searchable(text: $searchText, prompt: "Search for clave")
        // MARK: USER
        .onReceive(userViewModel.$user) { user in
            self.user = user
        }
        // MARK: CLAVES
        .onReceive(claveViewModel.$emptyClaveValues) { isEmptyClavesValue in
            emptyClaveValues = isEmptyClavesValue
        }
        .onReceive(claveViewModel.$claves) { newClaves in
            let clavesToDelete = self.claves.filter { oldClave in
                return !newClaves.contains(where: {$0.id == oldClave.id})
            }
            let clavesToAdd = newClaves.filter { newClave in
                return !self.claves.contains(where: {$0.id == newClave.id})
            }
            let clavesToUpdate = newClaves.filter { oldClave in
                return oldClave.id == self.updatedClave.id
            }
            // DELETE
            for clave in clavesToDelete {
                if let indexToRemove = self.claves.firstIndex(where: {$0.id == clave.id}) {
                    withAnimation(.linear(duration: 0.2)) {
                        self.claves.remove(at: indexToRemove)
                    }
                }
            }
            // ADD
            for clave in clavesToAdd {
                if let indexToAdd = newClaves.firstIndex(where: {$0.id == clave.id}) {
                    withAnimation(.linear(duration: 0.2)) {
                        self.claves.insert(clave, at: indexToAdd)
                    }
                }
            }
            // UPDATE
            for clave in clavesToUpdate {
                withAnimation(.linear(duration: 0.2)) {
                    self.claves = self.claves.map({ c in
                        var newClave = c
                        if newClave.id == clave.id {
                            newClave = clave
                        }
                        return newClave
                    })
                }
            }
            if clavesToAdd.isEmpty && clavesToDelete.isEmpty && clavesToUpdate.isEmpty {
                withAnimation(.linear(duration: 0.2)) {
                    self.claves = newClaves
                }
            }
            searchText = "&&"
            searchText = ""
        }
        .onReceive(claveViewModel.$updatedClave, perform: { clave in
            updatedClave = clave
        })
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
extension ClavesLandingView {
    func onAddClave(titulo: String, valores: Valores) {
        claveViewModel.addClave(titulo: titulo, valores: valores)
    }
    
    func onDeleteClave(clave: Clave) {
        clearBottomSheets()
        claveViewModel.deleteClave(clave: clave)
    }
    
    func onUpdateClave(clave: Clave) {
        clearBottomSheets()
        claveViewModel.updateClave(clave: clave)
    }
    
    func clearBottomSheets() {
        showCreateKey = false
        showClave = false
        selectedClave = Clave()
    }
    
    func removeUpdatedClave() {
        updatedClave = Clave()
    }
}
// MARK: CLAVE ORDER
extension ClavesLandingView {
    func azSelection() {
        CLAVE_ORDER_TYPE = .AZ
        claveViewModel.sortClaves()
    }
    func zaSelection() {
        CLAVE_ORDER_TYPE = .ZA
        claveViewModel.sortClaves()
    }
    func newFirstSelection() {
        CLAVE_ORDER_TYPE = .newFirst
        claveViewModel.sortClaves()
    }
    func oldFirstselection() {
        CLAVE_ORDER_TYPE = .oldFirst
        claveViewModel.sortClaves()
    }
}

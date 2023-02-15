//
//  ClaveViewModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 1/6/22.
//

import Foundation
import Combine
import CoreData
import SwiftUI

enum ClaveSavingState {
    case none
    case saving
    case locallySaved
    case serverSaved
    case errorSavingToServer
}

enum ClaveOrderType {
    case AZ
    case ZA
    case newFirst
    case oldFirst
}

class ClaveViewModel: NSObject, ObservableObject {
    
    @Published var claves: [Clave] = []
    @Published var updatedClave: Clave = Clave()
    
    var dbClaves: [ClaveDB] = []
    @Published var claveSavingState: ClaveSavingState = .none
    
    // Errors
    @Published var emptyClaveValues: Bool = false
    
    var getClavesCancellable: Cancellable?
    var addClaveCancellable: Cancellable?
    
    private let claveController: NSFetchedResultsController<ClaveDB>
    
    // Init with local objects and then try to update data with server
    init(managedObjectContext: NSManagedObjectContext) {
        claveController = NSFetchedResultsController(fetchRequest: ClaveDB.claveDBFetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        super.init()
        claveController.delegate = self
        do {
            try claveController.performFetch()
            self.dbClaves = claveController.fetchedObjects ?? []
            claves = GlobalManager.shared.orderClaves(clavesToOrder: dbClaves.compactMap({Clave.parseClaveDB($0)}))
            print("Local Claves: \(claves)")
        } catch {
          print("failed to fetch items!")
        }
    }
}

// MARK: GET CLAVES
extension ClaveViewModel {
    func getClaves(tokenUsuario: String?) {
        if let tokenUsuario = tokenUsuario, tokenUsuario != "" {
            getClavesCancellable = getClavesCall(userToken: tokenUsuario).sink(receiveCompletion: {
                switch $0 {
                case .failure(let err):
                    guard let _ = err as? TofyError else {
                        return
                    }
                    return
                case .finished: ()
                }
            }, receiveValue: { claves in
                print(claves)
                for clave in claves.claves {
                    self.saveClaveLocally(claveToSave: Clave(token: clave.token,
                                                             tokenUsuario: clave.tokenUsuario,
                                                             titulo: clave.titulo,
                                                             valor: clave.valor,
                                                             usuario: clave.usuario,
                                                             contrasena: clave.contrasena,
                                                             fecha: clave.fecha,
                                                             actualizado: true))
                }
            })
        }
    }
    
    func getClavesCall(userToken: String) -> AnyPublisher<ClavesResponse, Error> {
        return crearLlamada(url: getAllClavesUrl,
                     parametros: [
                        "token": userToken
                     ]).eraseToAnyPublisher()
    }
}

// MARK: ADD CLAVE
extension ClaveViewModel {
    func addClave(titulo: String, valor: String, usuario: String, contrasena: String) {
        if checkAddClaveParams(titulo: titulo, valor: valor, usuario: usuario, contrasena: contrasena) {
            claveSavingState = .saving
            let claveToken = GlobalManager.shared.generateToken()
            let claveFecha = Date().toString()
            let claveToSave = Clave(token: claveToken,
                                    tokenUsuario: USER_TOKEN,
                                    titulo: titulo,
                                    valor: valor,
                                    usuario: usuario,
                                    contrasena: contrasena,
                                    fecha: claveFecha,
                                    actualizado: false)
            self.saveClaveLocally(claveToSave: claveToSave)
            self.claveSavingState = .locallySaved
            addClaveCancellable = addClaveCall(token: claveToken, userToken: USER_TOKEN, titulo: titulo, valor: valor, usuario: usuario, contrasena: contrasena, fecha: claveFecha).sink(receiveCompletion: {
                switch $0 {
                case .failure(let err):
                    self.claveSavingState = .errorSavingToServer
                case .finished: ()
                }
            }, receiveValue: { clave in
                self.saveClaveLocally(claveToSave: Clave(token: clave.token,
                                                         tokenUsuario: clave.tokenUsuario,
                                                         titulo: clave.titulo,
                                                         valor: clave.valor,
                                                         usuario: clave.usuario,
                                                         contrasena: clave.contrasena,
                                                         fecha: clave.fecha,
                                                         actualizado: true))
                self.claveSavingState = .serverSaved
            })
        }
    }
    
    func checkAddClaveParams(titulo: String, valor: String, usuario: String, contrasena: String) -> Bool {
        emptyClaveValues = false
        if titulo.isEmpty || (valor.isEmpty && (usuario.isEmpty || contrasena.isEmpty)) {
            emptyClaveValues = true
            return false
        } else {
            return true
        }
    }
    
    func addClaveCall(token: String, userToken: String, titulo: String, valor: String, usuario: String, contrasena: String, fecha: String) -> AnyPublisher<Clave, Error> {
        return crearLlamada(url: addClaveUrl,
                     parametros: [
                        "usuarioToken": userToken,
                        "token": token,
                        "titulo": titulo,
                        "valor": valor,
                        "usuario": usuario,
                        "contrasena": contrasena,
                        "fecha": fecha
                     ]).eraseToAnyPublisher()
    }
}
// MARK: DELETE
extension ClaveViewModel {
    public func deleteClave(clave: Clave) {
        deleteClaveLocally(clave: clave)
    }
}
// MARK: UPDATE
extension ClaveViewModel {
    public func updateClave(clave: Clave) {
        updatedClave = clave
        updateClaveLocally(clave: clave)
    }
}

// MARK: LOCALLY
extension ClaveViewModel: NSFetchedResultsControllerDelegate {
    private func saveClaveLocally(claveToSave: Clave) {
        PersistenceController.shared.saveClave(clave: claveToSave, allLocalClaves: self.dbClaves)
    }
    
    private func deleteClaveLocally(clave: Clave) {
        guard let claveDBItemToDelete = dbClaves.filter({$0.token == clave.token}).first else { return }
        PersistenceController.shared.deleteClave(clave: claveDBItemToDelete)
    }
    
    private func updateClaveLocally(clave: Clave) {
        if let claveToChange = dbClaves.filter({$0.token == clave.token}).first {
            PersistenceController.shared.updateClave(oldClave: claveToChange, newClave: clave)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let claveItems = controller.fetchedObjects as? [ClaveDB] else { return }
        dbClaves = claveItems
        claves = GlobalManager.shared.orderClaves(clavesToOrder: dbClaves.map({Clave.parseClaveDB($0)}))
    }
}

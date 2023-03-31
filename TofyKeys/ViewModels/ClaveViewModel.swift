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

enum ClaveOrderType: String {
    case AZ = "A-Z"
    case ZA = "Z-A"
    case newFirst = "New first"
    case oldFirst = "Old first"
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
    
    func sortClaves() {
        claves = GlobalManager.shared.orderClaves(clavesToOrder: dbClaves.compactMap({Clave.parseClaveDB($0)}))
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
                ()
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
    func addClave(titulo: String, valores: Valores) {
        if checkAddClaveParams(titulo: titulo, valores: valores) {
            claveSavingState = .saving
            let claveToken = GlobalManager.shared.generateToken()
            let claveFecha = Date().toString()
            let claveToSave = Clave(id: UUID().uuidString,
                                    tokenUsuario: USER_TOKEN,
                                    titulo: titulo,
                                    valores: valores,
                                    fecha: claveFecha,
                                    actualizado: false,
                                    isFavourite: false)
            self.saveClaveLocally(claveToSave: claveToSave)
            self.claveSavingState = .locallySaved
            addClaveCancellable = addClaveCall(token: claveToken, userToken: USER_TOKEN, titulo: titulo, valores: valores, fecha: claveFecha).sink(receiveCompletion: {
                switch $0 {
                case .failure(let err):
                    self.claveSavingState = .errorSavingToServer
                case .finished: ()
                }
            }, receiveValue: { clave in
                self.claveSavingState = .serverSaved
            })
        }
    }
    
    func checkAddClaveParams(titulo: String, valores: Valores) -> Bool {
        emptyClaveValues = false
        if titulo.isEmpty || valores.valor.isEmpty {
            emptyClaveValues = true
            return false
        } else {
            return true
        }
    }
    
    func addClaveCall(token: String, userToken: String, titulo: String, valores: Valores, fecha: String) -> AnyPublisher<Clave, Error> {
        return crearLlamada(url: addClaveUrl,
                     parametros: [
                        "usuarioToken": userToken,
                        "token": token,
                        "titulo": titulo,
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
// MARK: FAVOURITE
extension ClaveViewModel {
    public func setFavourite(clave: Clave) {
        let claveToChange = Clave(id: clave.id.uuidString,
                                  tokenUsuario: clave.tokenUsuario,
                                  titulo: clave.titulo,
                                  valores: clave.valores,
                                  fecha: clave.fecha,
                                  actualizado: false,
                                  isFavourite: clave.isFavourite ? false : true)
        updateClaveLocally(clave: claveToChange)
    }
}

// MARK: LOCALLY
extension ClaveViewModel: NSFetchedResultsControllerDelegate {
    private func saveClaveLocally(claveToSave: Clave) {
        PersistenceController.shared.saveClave(clave: claveToSave, allLocalClaves: self.dbClaves)
    }
    
    private func deleteClaveLocally(clave: Clave) {
        guard let claveDBItemToDelete = dbClaves.filter({$0.idClave == clave.id.uuidString}).first else { return }
        PersistenceController.shared.deleteClave(clave: claveDBItemToDelete)
    }
    
    private func updateClaveLocally(clave: Clave) {
        if let claveToChange = dbClaves.filter({$0.idClave == clave.id.uuidString}).first {
            PersistenceController.shared.updateClave(oldClave: claveToChange, newClave: clave)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let claveItems = controller.fetchedObjects as? [ClaveDB] else { return }
        dbClaves = claveItems
        claves = GlobalManager.shared.orderClaves(clavesToOrder: dbClaves.map({Clave.parseClaveDB($0)}))
    }
}

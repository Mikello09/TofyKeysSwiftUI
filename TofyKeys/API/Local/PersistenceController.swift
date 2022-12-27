//
//  PersistenceController.swift
//  TofyKeys
//
//  Created by Mikel on 31/3/22.
//

import Foundation
import CoreData


struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // A test configuration for SwiftUI previews
    static var userPreview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        let user = UserDB(context: controller.container.viewContext)

        return controller
    }()
    
    // An initializer to load Core Data, optionally able
        // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "TofyKeys")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error in save process: \(error)")
            }
        }
    }
}

// MARK: USER
extension PersistenceController {
    func saveUser(user: User) {
        let newUser = UserDB(context: container.viewContext)
        
        newUser.token = user.token
        newUser.email = user.email
        newUser.contrasena = user.pass
        newUser.name = user.nombre
        newUser.grupo = user.grupo
        newUser.character = user.character
        
        save()
    }
}

// MARK: CLAVE
extension PersistenceController {
    func saveClave(clave: Clave, allLocalClaves: [ClaveDB]) {
        if let claveToUpdate = allLocalClaves.filter({$0.token == clave.token}).first {
            claveToUpdate.actualizado = true
        } else {
            let newClave = ClaveDB(context: container.viewContext)
            
            newClave.tokenUsuario = clave.tokenUsuario
            newClave.token = clave.token
            newClave.titulo = clave.titulo
            newClave.usuario = clave.usuario
            newClave.contrasena = clave.contrasena
            newClave.valor = clave.valor
            newClave.fecha = clave.fecha
            newClave.actualizado = clave.actualizado
        }
        save()
    }
    
    func editClave(oldClave: ClaveDB, newClave: Clave) {
        var claveToChange = oldClave
        claveToChange.titulo = newClave.titulo
        claveToChange.valor = newClave.valor
        claveToChange.usuario = newClave.usuario
        claveToChange.contrasena = newClave.contrasena
        
        save()
    }
    
    func deleteClave(clave: ClaveDB) {
        let context = container.viewContext
        context.delete(clave)
        do {
            try context.save()
        } catch {
            print("Error deleting clave")
        }
    }
}

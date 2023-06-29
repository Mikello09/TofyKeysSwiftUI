//
//  ClaveBD.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation

extension PersistenceController {
    func saveClave(clave: Clave, allLocalClaves: [ClaveDB]) {
        if let claveToUpdate = allLocalClaves.filter({$0.idClave == clave.id.uuidString}).first {
            claveToUpdate.actualizado = true
        } else {
            let newClave = ClaveDB(context: container.viewContext)
            
            newClave.tokenUsuario = clave.tokenUsuario
            newClave.idClave = "\(clave.id)"
            newClave.titulo = clave.titulo
            if let valores = clave.valores {
                newClave.valores = valores//ValoresArray(valores: clave.valores)
            }
            newClave.fecha = clave.fecha
            newClave.actualizado = clave.actualizado
        }
        save()
    }
    
    func updateClave(oldClave: ClaveDB, newClave: Clave) {
        var claveToChange = oldClave
        claveToChange.titulo = newClave.titulo
        claveToChange.isFavourite = newClave.isFavourite
        claveToChange.valores = newClave.valores
        
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

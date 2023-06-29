//
//  UserDB.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation

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

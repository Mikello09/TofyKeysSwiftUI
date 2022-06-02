//
//  User.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import CoreData

struct UserResponse: Codable {
    var usuario: User
}

struct User: Codable {
    var token: String
    var nombre: String?
    var email: String
    var pass: String
    var grupo: String?
    var character: String?
    
    static func parseUserDB(_ userDB: UserDB?) -> User {
        return User(token: userDB?.token ?? "",
                    nombre: userDB?.name ?? "",
                    email: userDB?.email ?? "",
                    pass: userDB?.contrasena ?? "",
                    grupo: userDB?.grupo ?? "",
                    character: userDB?.character ?? "")
    }
    
    func getUserImage() -> String {
        if let character = character, character != "" {
            return character
        } else {
            return "user"
        }
    }
    
    func isLogged() -> Bool {
        return self.token != ""
    }
}

extension UserDB {
  static var userDBFetchRequest: NSFetchRequest<UserDB> {
    let request: NSFetchRequest<UserDB> = UserDB.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
    return request
  }
}

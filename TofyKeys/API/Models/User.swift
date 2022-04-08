//
//  User.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation


struct User: Codable {
    var token: String
    var name: String
    var email: String
    var pass: String
    
    static func parseUserDB(_ userDB: UserDB?) -> User {
        return User(token: userDB?.name ?? "",
                    name: userDB?.email ?? "",
                    email: userDB?.email ?? "",
                    pass: userDB?.contrasena ?? "")
    }
}

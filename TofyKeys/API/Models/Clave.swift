//
//  Clave.swift
//  TofyKeys
//
//  Created by Mikel on 31/3/22.
//

import Foundation
import CoreData
import SwiftUI

struct ClavesResponse: Codable {
    var claves: [Clave]
}

struct Clave: Codable, Identifiable {
    var id: UUID = UUID()
    var token: String
    var tokenUsuario: String
    var titulo: String
    var valor: String
    var usuario: String
    var contrasena: String
    var fecha: String
    var actualizado: Bool = false
    
    static func parseClaveDB(_ claveDB: ClaveDB) -> Clave {
        return Clave(token: claveDB.token ?? "",
                     tokenUsuario: claveDB.tokenUsuario ?? "",
                     titulo: claveDB.titulo ?? "",
                     valor: claveDB.valor ?? "",
                     usuario: claveDB.usuario ?? "",
                     contrasena: claveDB.contrasena ?? "",
                     fecha: claveDB.fecha ?? "",
                     actualizado: claveDB.actualizado ?? false)
    }
}

enum ClaveType {
    case value
    case userPass
    
    func getTitle() -> LocalizedStringKey {
        switch self {
        case .value: return LocalizedStringKey("ValueTitle")
        case .userPass: return LocalizedStringKey("UserPassTitle")
        }
    }
    
}

extension ClaveDB {
  static var claveDBFetchRequest: NSFetchRequest<ClaveDB> {
    let request: NSFetchRequest<ClaveDB> = ClaveDB.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: true)]
    return request
  }
}

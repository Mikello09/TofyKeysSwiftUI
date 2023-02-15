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

enum TipoRecordatorio {
    case clave
    case userPass
    case lista
    case aparcamiento
    case fecha
    case foto
    case texto
}

struct Valores: Codable, Equatable, Hashable {
    var tipo: String
    var valor: String
}

struct Clave: Codable, Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var token: String
    var tokenUsuario: String
    var titulo: String
    var valores: [Valores]
    var fecha: String
    var actualizado: Bool = false
    
    public init() {
        token = ""
        tokenUsuario = ""
        titulo = ""
        valores = []
        fecha = ""
        actualizado = false
    }
    
    public init(token: String, tokenUsuario: String, titulo: String, valores: [Valores], fecha: String, actualizado: Bool) {
        self.token = token
        self.tokenUsuario = tokenUsuario
        self.titulo = titulo
        self.valores = valores
        self.fecha = fecha
        self.actualizado = actualizado
    }
    
    static func parseClaveDB(_ claveDB: ClaveDB) -> Clave {
        return Clave(token: claveDB.token ?? "",
                     tokenUsuario: claveDB.tokenUsuario ?? "",
                     titulo: claveDB.titulo ?? "",
                     valores: claveDB
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
      
      let request2: NSFetchRequest<ValoresDB> = ValoresDB.fetchRequest()
      
      return request
  }
}

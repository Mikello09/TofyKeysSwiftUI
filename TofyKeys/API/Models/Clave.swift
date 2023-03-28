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

public class Valores: NSObject, Codable, NSSecureCoding {
    public static var supportsSecureCoding: Bool{ get{ return true } }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(tipo, forKey: "tipo")
        coder.encode(valor, forKey: "valor")
    }
    
    public required init?(coder: NSCoder) {
        if let id = coder.decodeObject(forKey: "id") as? UUID {
            self.id = id
        }
        if let tipo = coder.decodeObject(forKey: "tipo") as? String {
            self.tipo = tipo
        }
        if let valor = coder.decodeObject(forKey: "valor") as? String {
            self.valor = valor
        }
    }
    
    public override init() {}
    
    public init(tipo: String, valor: String) {
        self.tipo = tipo
        self.valor = valor
    }
    
    public var id: UUID = UUID()
    public var tipo: String = ""
    public var valor: String = ""
    
    func getClaveType() -> ClaveType {
        switch tipo {
        case "clave": return .clave
        case "userPass": return .userPass
        case "lista": return .lista
        case "aparcamiento": return .aparcamiento
        case "foto": return .foto
        case "texto": return .texto
        default: return .clave
        }
    }
}

struct Clave: Codable, Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var tokenUsuario: String
    var titulo: String
    var valores: Valores?
    var fecha: String
    var actualizado: Bool = false
    
    public init() {
        tokenUsuario = ""
        titulo = ""
        fecha = ""
        actualizado = false
    }
    
    public init(id: String, tokenUsuario: String, titulo: String, valores: Valores?, fecha: String, actualizado: Bool) {
        self.id = UUID(uuidString: id) ?? UUID()
        self.tokenUsuario = tokenUsuario
        self.titulo = titulo
        self.valores = valores
        self.fecha = fecha
        self.actualizado = actualizado
    }
    
    static func parseClaveDB(_ claveDB: ClaveDB) -> Clave {
        return Clave(id: claveDB.idClave ?? "",
                     tokenUsuario: claveDB.tokenUsuario ?? "",
                     titulo: claveDB.titulo ?? "",
                     valores: claveDB.valores,
                     fecha: claveDB.fecha ?? "",
                     actualizado: claveDB.actualizado)
    }
}

let VALUE_SEPARATOR: String = "$%&"

enum ClaveType: String {
    case clave = "clave"
    case userPass = "userPass"
    case lista = "lista"
    case aparcamiento = "aparcamiento"
    case foto = "foto"
    case texto = "texto"
    
    func getTitle() -> LocalizedStringKey {
        switch self {
        case .clave: return LocalizedStringKey("ClaveTitle")
        case .userPass: return LocalizedStringKey("UserPassTitle")
        case .lista: return LocalizedStringKey("ListTitle")
        case .aparcamiento: return LocalizedStringKey("ParkingTitle")
        case .foto: return LocalizedStringKey("PhotoTitle")
        case .texto: return LocalizedStringKey("TextTitle")
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .clave: return 550
        case .userPass: return 650
        case .lista: return 550
        case .aparcamiento: return 550
        case .foto: return 550
        case .texto: return 550
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

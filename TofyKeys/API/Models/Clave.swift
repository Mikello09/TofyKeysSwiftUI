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
// MARK: VALORES
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
// MARK: CLAVE
struct Clave: Codable, Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var tokenUsuario: String
    var titulo: String
    var valores: Valores?
    var fecha: String
    var actualizado: Bool = false
    var isFavourite: Bool
    
    public init() {
        tokenUsuario = ""
        titulo = ""
        fecha = ""
        actualizado = false
        isFavourite = false
    }
    
    public init(id: String, tokenUsuario: String, titulo: String, valores: Valores?, fecha: String, actualizado: Bool, isFavourite: Bool) {
        self.id = UUID(uuidString: id) ?? UUID()
        self.tokenUsuario = tokenUsuario
        self.titulo = titulo
        self.valores = valores
        self.fecha = fecha
        self.actualizado = actualizado
        self.isFavourite = isFavourite
    }
    
    static func parseClaveDB(_ claveDB: ClaveDB) -> Clave {
        return Clave(id: claveDB.idClave ?? "",
                     tokenUsuario: claveDB.tokenUsuario ?? "",
                     titulo: claveDB.titulo ?? "",
                     valores: claveDB.valores,
                     fecha: claveDB.fecha ?? "",
                     actualizado: claveDB.actualizado,
                     isFavourite: claveDB.isFavourite)
    }
    
    func toParking() -> Parking? {
        if let parkingInfo = valores?.valor.split(separator: VALUE_SEPARATOR) {
            var reference = ""
            var color = "-"
            var latitude: CGFloat = 0
            var longitude: CGFloat = 0
            for (index, info) in parkingInfo.enumerated() {
                if index == 0 {
                    reference = info.description
                } else if index == 1 {
                    color = info.description
                } else if index == 2 {
                    latitude = CGFloat(Double(info.description) ?? 0)
                } else {
                    longitude = CGFloat(Double(info.description) ?? 0)
                }
            }
            return Parking(reference: reference, color: color, latitude: latitude, longitude: longitude, date: titulo.toDate())
        }
        return nil
    }
    
    func toNota() -> Nota? {
        guard let notaValue = valores?.valor else { return nil }
        return Nota(id: self.id, tokenUsuario: self.tokenUsuario, titulo: self.titulo, nota: notaValue, fecha: fecha, actualizado: actualizado, isFavourite: isFavourite)
    }
}

let VALUE_SEPARATOR: String = "$%&"
// MARK: CLAVE TYPE
enum ClaveType: String, Identifiable {
    
    var id: Self { return self }
    
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
    
    func getImage() -> Image {
        switch self {
        case .clave: return Image(systemName: "key.fill")
        case .userPass: return Image(systemName: "person.circle.fill")
        case .lista: return Image(systemName: "list.clipboard.fill")
        case .aparcamiento: return Image(systemName: "car.fill")
        case .foto: return Image(systemName: "photo.fill")
        case .texto: return Image(systemName: "note.text")
        }
    }
    
    func getFraction() -> CGFloat {
        switch self {
        case .clave: return 0.5
        case .userPass: return 0.6
        case .lista: return 0.6
        case .aparcamiento: return 0.75
        case .foto: return 0.6
        case .texto: return 0.6
        }
    }
    
}

// MARK: CLAVE DB
extension ClaveDB {
  static var claveDBFetchRequest: NSFetchRequest<ClaveDB> {
      let request: NSFetchRequest<ClaveDB> = ClaveDB.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: true)]
      return request
  }
}

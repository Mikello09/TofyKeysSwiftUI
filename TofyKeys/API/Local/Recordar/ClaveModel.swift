//
//  ClaveModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/2/25.
//

import Foundation
import SwiftData

@Model
final class Clave {
    var id: UUID
    var titulo: String
    var creationDate: Date
    var lastModified: Date
    var items: [ClaveItem]
    
    init(id: UUID, titulo: String, creationDate: Date, lastModified: Date, items: [ClaveItem]) {
        self.id = id
        self.titulo = titulo
        self.creationDate = creationDate
        self.lastModified = lastModified
        self.items = items
    }
}

@Model
final class ClaveItem {
    var id: UUID
    var idClave: UUID
    var tipo: String // valor/user/password
    var valor: String
    var orderNumber: Int
    
    init(id: UUID, idClave: UUID, tipo: String, valor: String, orderNumber: Int) {
        self.id = id
        self.idClave = idClave
        self.tipo = tipo
        self.valor = valor
        self.orderNumber = orderNumber
    }
}


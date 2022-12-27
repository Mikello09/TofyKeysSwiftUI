//
//  GlobalManager.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 2/6/22.
//

import Foundation

class GlobalManager {
    static var shared: GlobalManager = GlobalManager()
}

// USER
var USER_TOKEN: String = ""
extension GlobalManager {
    func generateToken() -> String {
        return UUID().uuidString
    }
}

// CLAVES
var CLAVE_ORDER_TYPE: ClaveOrderType = .AZ
extension GlobalManager {
    func orderClaves(clavesToOrder: [Clave]) -> [Clave] {
        switch CLAVE_ORDER_TYPE {
        case .AZ:
            return clavesToOrder.sorted { c1, c2 in
                c1.titulo < c2.titulo
            }
        case .ZA:
            return clavesToOrder.sorted { c1, c2 in
                c1.titulo > c2.titulo
            }
        case .newFirst:
            return clavesToOrder.sorted { c1, c2 in
                c1.fecha.toDate() < c2.titulo.toDate()
            }
        case .oldFirst:
            return clavesToOrder.sorted { c1, c2 in
                c1.fecha.toDate() > c2.titulo.toDate()
            }
        }
    }
}

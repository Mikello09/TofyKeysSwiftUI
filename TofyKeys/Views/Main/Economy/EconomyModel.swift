//
//  EconomyModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation
import CoreData
import SwiftUI

// MARK: PERIODO
struct Periodo: Codable {
    var id: UUID
    var titulo: String
    var fechaInicio: Date
    var fechaFinal: Date?
    var ingresos: [Transaccion]
    var gastos: [Transaccion]
    var tipo: String
    var estado: String
    var accion: String
    
    static func parsePeriodoDB(_ periodoDB: PeriodoDB) -> Periodo {
        return Periodo(id: periodoDB.id ?? UUID(),
                       titulo: periodoDB.titulo ?? "",
                       fechaInicio: periodoDB.fechaInicio ?? Date(),
                       fechaFinal: periodoDB.fechaFinal,
                       ingresos: periodoDB.ingresos?.allObjects.compactMap({$0 as? TransaccionDB}).compactMap({ Transaccion.parseTransaccionDB($0) }) ?? [],
                       gastos: periodoDB.gastos?.allObjects.compactMap({$0 as? TransaccionDB}).compactMap({ Transaccion.parseTransaccionDB($0) }) ?? [],
                       tipo: periodoDB.tipo ?? "manual",
                       estado: periodoDB.estado ?? "",
                       accion: periodoDB.accion ?? "")
    }
    
    func getIngresosValue() -> Double {
        var ingresosValue: Double = 0
        ingresos.forEach({ ingresosValue += $0.valor })
        return ingresosValue
    }
    
    func getGastosValue() -> Double {
        var gastosValue: Double = 0
        gastos.forEach({ gastosValue += $0.valor })
        return gastosValue
    }

    func getIngresosGastosDifference() -> Double {
        var ingresosValue: Double = 0
        ingresos.forEach({ ingresosValue += $0.valor })
        var gastosValue: Double = 0
        gastos.forEach({ gastosValue += $0.valor })
        return (ingresosValue - gastosValue)
    }
    
}
// MARK: TRANSACCION
struct Transaccion: Codable, Hashable {
    var id: UUID
    var titulo: String
    var tipo: String// gasto / ingreso
    var valor: Double
    var category: UUID
    var observacion: String
    
    static func parseTransaccionDB(_ transaccionDB: TransaccionDB) -> Transaccion {
        return Transaccion(id: transaccionDB.id ?? UUID(),
                           titulo: transaccionDB.titulo ?? "",
                           tipo: transaccionDB.tipo ?? "",
                           valor: transaccionDB.valor,
                           category: transaccionDB.category ?? UUID(),
                           observacion: transaccionDB.observacion ?? "")
    }
}

struct Category: Hashable {
    var id: UUID
    var image: Image
    var title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: CUENTA
struct Cuenta: Codable {
    var titulo: String
    var total: Double
}

// MARK: PRESUPUESTO
struct Presupuesto: Codable {
    var titulo: String
    var valorInicial: Double
    var gastado: Double
}


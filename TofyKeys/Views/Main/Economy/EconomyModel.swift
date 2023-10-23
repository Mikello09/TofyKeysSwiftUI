//
//  EconomyModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation
import CoreData
import SwiftUI

enum TipoProducto: String {
    case contabilidadManual
    case contabilidadMensual
    case cuenta
    case presupuesto
    case gastos
}

// MARK: PERIODO
struct Periodo: Codable, Hashable {
    var id: UUID
    var titulo: String
    var fechaInicio: Date
    var fechaFinal: Date?
    var transacciones: [Transaccion]
    var tipo: String
    var estado: String
    var accion: String
    
    static func parsePeriodoDB(_ periodoDB: PeriodoDB) -> Periodo {
        return Periodo(id: periodoDB.id ?? UUID(),
                       titulo: periodoDB.titulo ?? "",
                       fechaInicio: periodoDB.fechaInicio ?? Date(),
                       fechaFinal: periodoDB.fechaFinal,
                       transacciones: periodoDB.transacciones?.allObjects.compactMap({$0 as? TransaccionDB}).compactMap({ Transaccion.parseTransaccionDB($0) }) ?? [],
                       tipo: periodoDB.tipo ?? TipoProducto.contabilidadManual.rawValue,
                       estado: periodoDB.estado ?? "",
                       accion: periodoDB.accion ?? "")
    }

    func getGastos() -> Double {
        var gastos: Double = 0
        transacciones.filter({ $0.tipo == "gasto" }).forEach({ gastos += $0.valor })
        return gastos
    }
    
    func getIngresos() -> Double {
        var ingresos: Double = 0
        transacciones.filter({ $0.tipo == "ingreso" }).forEach({ ingresos += $0.valor })
        return ingresos
    }
    
    func getIngresosGastosDifference() -> Double {
        var resultado:Double = 0
        transacciones.forEach({ resultado += ($0.tipo == "gasto" ? ($0.valor*(-1)) : $0.valor) })
        return resultado
    }
    
    func isContabilidad() -> Bool {
        return self.tipo == TipoProducto.contabilidadManual.rawValue || self.tipo == TipoProducto.contabilidadMensual.rawValue
    }
    
}
// MARK: TRANSACCION
struct Transaccion: Codable, Hashable, Identifiable {
    var id: UUID
    var titulo: String
    var tipo: String// gasto / ingreso
    var valor: Double
    var category: UUID
    var fecha: Date
    var observacion: String
    
    static func parseTransaccionDB(_ transaccionDB: TransaccionDB) -> Transaccion {
        return Transaccion(id: transaccionDB.id ?? UUID(),
                           titulo: transaccionDB.titulo ?? "",
                           tipo: transaccionDB.tipo ?? "",
                           valor: transaccionDB.valor,
                           category: transaccionDB.category ?? UUID(),
                           fecha: transaccionDB.fecha ?? Date(),
                           observacion: transaccionDB.observacion ?? "")
    }
}

struct Category: Hashable, Identifiable {
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


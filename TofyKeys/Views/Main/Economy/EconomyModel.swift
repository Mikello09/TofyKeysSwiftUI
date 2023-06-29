//
//  EconomyModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation
import CoreData

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
}

struct Transaccion: Codable {
    var id: UUID
    var titulo: String
    var tipo: String// gasto / ingreso
    var valor: Double
    
    static func parseTransaccionDB(_ transaccionDB: TransaccionDB) -> Transaccion {
        return Transaccion(id: transaccionDB.id ?? UUID(),
                           titulo: transaccionDB.titulo ?? "",
                           tipo: transaccionDB.tipo ?? "",
                           valor: transaccionDB.valor)
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


// MARK: CLAVE DB
extension PeriodoDB {
  static var periodoDBFetchRequest: NSFetchRequest<PeriodoDB> {
      let request: NSFetchRequest<PeriodoDB> = PeriodoDB.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "fechaInicio", ascending: true)]
      return request
  }
}

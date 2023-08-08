//
//  EconomyDB.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation
import CoreData

extension PersistenceController {
    
    func addPeriodoActual(periodo: Periodo) {
        let newPeriodo = PeriodoDB(context: container.viewContext)

        newPeriodo.id = periodo.id
        newPeriodo.titulo = periodo.titulo
        newPeriodo.fechaInicio = periodo.fechaInicio
        newPeriodo.fechaFinal = periodo.fechaFinal
        newPeriodo.tipo = periodo.tipo
        newPeriodo.accion = periodo.accion
        newPeriodo.estado = periodo.estado
        
        save()
    }
    
    func addTransactionToPeriodoActual(allPeriodos: [PeriodoDB], periodo: Periodo, transaction: Transaccion) {
        
        let transaccionDB = TransaccionDB(context: container.viewContext)
        transaccionDB.id = transaction.id
        transaccionDB.tipo = transaction.tipo
        transaccionDB.titulo = transaction.titulo
        transaccionDB.valor = transaction.valor
        transaccionDB.category = transaction.category
        
        if var periodoToUpdate = allPeriodos.filter({$0.id == periodo.id}).first {
            switch transaction.tipo {
            case "gasto":
                var gastos = periodoToUpdate.mutableSetValue(forKey: "gastos")
                gastos.add(transaccionDB)
            case "ingreso":
                var ingresos = periodoToUpdate.mutableSetValue(forKey: "ingresos")
                ingresos.add(transaccionDB)
            default: ()
            }
            save()
        }
    }
    
    func deleteGasto(transaction: TransaccionDB, periodo: PeriodoDB) {
        periodo.removeFromGastos(transaction)
        deleteTransaction(transaction)
    }
    
    func deleteIngreso(transaction: TransaccionDB, periodo: PeriodoDB) {
        periodo.removeFromIngresos(transaction)
        deleteTransaction(transaction)
    }
    
    func deleteTransaction(_ transaction: TransaccionDB) {
        container.viewContext.delete(transaction)
        save()
    }

}

extension PeriodoDB {
  static var periodoDBFetchRequest: NSFetchRequest<PeriodoDB> {
      let request: NSFetchRequest<PeriodoDB> = PeriodoDB.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "fechaInicio", ascending: true)]
      return request
  }
}

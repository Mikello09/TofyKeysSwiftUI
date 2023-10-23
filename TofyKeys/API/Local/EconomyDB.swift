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
        
        if let valorInicial = periodo.transacciones.first {
            
            let transaccionDB = TransaccionDB(context: container.viewContext)
            transaccionDB.id = valorInicial.id
            transaccionDB.tipo = valorInicial.tipo
            transaccionDB.titulo = valorInicial.titulo
            transaccionDB.valor = valorInicial.valor
            transaccionDB.fecha = valorInicial.fecha
            transaccionDB.category = valorInicial.category
            
            let transacciones = newPeriodo.mutableSetValue(forKey: "transacciones")
            transacciones.add(transaccionDB)
        }
        
        save()
    }
    
    func addTransactionToPeriodoActual(allPeriodos: [PeriodoDB], periodo: Periodo, transaction: Transaccion) {
        
        let transaccionDB = TransaccionDB(context: container.viewContext)
        transaccionDB.id = transaction.id
        transaccionDB.tipo = transaction.tipo
        transaccionDB.titulo = transaction.titulo
        transaccionDB.valor = transaction.valor
        transaccionDB.fecha = transaction.fecha
        transaccionDB.category = transaction.category
        
        if let periodoToUpdate = allPeriodos.filter({$0.id == periodo.id}).first {
            let transacciones = periodoToUpdate.mutableSetValue(forKey: "transacciones")
            transacciones.add(transaccionDB)
            save()
        }
    }
    
    func deleteTransaction(_ transaction: TransaccionDB, periodo: PeriodoDB) {
        periodo.removeFromTransacciones(transaction)
        container.viewContext.delete(transaction)
        save()
    }
    
    func editTransaction(_ periodo: PeriodoDB, id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        
        var transacciones = periodo.mutableSetValue(forKey: "transacciones")
        if let transactionToEdit = (transacciones.allObjects as? [TransaccionDB])?.filter({ $0.id == id }).first {
            transactionToEdit.titulo = titulo
            transactionToEdit.tipo = tipo
            transactionToEdit.valor = valor
            transactionToEdit.category = category
            transactionToEdit.observacion = observacion
            transactionToEdit.fecha = fecha
        }
        save()
    }
    
    func closePeriodo(periodo: PeriodoDB) {
        periodo.estado = "cerrado"
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

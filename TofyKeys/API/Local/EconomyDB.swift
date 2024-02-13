//
//  EconomyDB.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation
import CoreData

extension PersistenceController {
    
    func addProducto(producto: Producto) {
        let newProducto = ProductoDB(context: container.viewContext)

        newProducto.id = producto.id
        newProducto.titulo = producto.titulo
        newProducto.fechaInicio = producto.fechaInicio
        newProducto.fechaFinal = producto.fechaFinal
        newProducto.tipo = producto.tipo
        newProducto.accion = producto.accion
        newProducto.valorInicial = producto.valorInicial
        
        save()
        
    }
    
    func deleteProducto(producto: ProductoDB) {
        container.viewContext.delete(producto)
    }
    
    func addTransactionToPeriodoActual(allPeriodos: [ProductoDB], periodo: Producto, transaction: Transaccion) {
        
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
    
    func deleteTransaction(_ transaction: TransaccionDB, periodo: ProductoDB) {
        periodo.removeFromTransacciones(transaction)
        container.viewContext.delete(transaction)
        save()
    }
    
    func editTransaction(_ periodo: ProductoDB, id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        
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

}

extension ProductoDB {
  static var productoDBFetchRequest: NSFetchRequest<ProductoDB> {
      let request: NSFetchRequest<ProductoDB> = ProductoDB.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "fechaInicio", ascending: true)]
      return request
  }
}

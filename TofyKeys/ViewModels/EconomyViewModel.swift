//
//  EconomyViewModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 25/6/23.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class EconomyViewModel: NSObject, ObservableObject {
    
    private let periodoController: NSFetchedResultsController<ProductoDB>
    @Published var dbProductos: [ProductoDB] = []
    @Published var productos: [Producto] = []
    @Published var transaciones: [Transaccion] = []
    
    init(managedObjectContext: NSManagedObjectContext) {
        periodoController = NSFetchedResultsController(fetchRequest: ProductoDB.productoDBFetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        super.init()
        periodoController.delegate = self
        do {
            try periodoController.performFetch()
            dbProductos = periodoController.fetchedObjects ?? []
            productos = dbProductos.compactMap( {Producto.parseProductoDB($0) })
            print("Periodos: \(dbProductos)")
        } catch {
          print("failed to fetch items!")
        }
    }
    
    func getProductos() {
        productos = dbProductos.compactMap( {Producto.parseProductoDB($0) })
    }
    
    func getTransacciones(producto: Producto, forDate: Date? = nil) {
        if let forDate {
            transaciones = producto.transacciones.filter({ $0.fecha >= forDate.startOfMonth && $0.fecha <= forDate.endOfMonth })
        } else {
            transaciones = producto.transacciones
        }
    }
    
    func addProducto(titulo: String, tipo: TipoProducto, valorInicial: String) {
        PersistenceController.shared.addProducto(producto: Producto(id: UUID(),
                                                                    titulo: titulo,
                                                                    fechaInicio: Date(),
                                                                    transacciones: [],
                                                                    tipo: tipo.rawValue,
                                                                    accion: "",
                                                                    valorInicial: Double(valorInicial) ?? 0))
    }
    
    func addTransaction(periodo: Producto, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        PersistenceController.shared.addTransactionToPeriodoActual(allPeriodos: dbProductos,
                                                                   periodo: periodo,
                                                                   transaction: Transaccion(id: UUID(),
                                                                                            titulo: titulo,
                                                                                            tipo: tipo,
                                                                                            valor: valor,
                                                                                            category: category,
                                                                                            fecha: fecha,
                                                                                            observacion: observacion))
    }
    
    func deletePeriodoTransaction(transactionID: UUID, periodo: Producto) {
        guard let productoDB = dbProductos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (productoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == transactionID }).first {
            PersistenceController.shared.deleteTransaction(transaction, periodo: productoDB)
        }
    }
    
    func editTransaction(periodo: Producto, id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        guard let productoDB = dbProductos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (productoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == id }).first {
            PersistenceController.shared.editTransaction(productoDB, id: id, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion, fecha: fecha)
            // El controller Did change content no salta y por eso hay que hacerlo "manual"
            try? periodoController.performFetch()
            dbProductos = periodoController.fetchedObjects ?? []
            productos = dbProductos.compactMap( {Producto.parseProductoDB($0) })
        }
    }
}

// MARK: PERIODO DB
extension EconomyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did changed")
        guard let periodoItems = controller.fetchedObjects as? [ProductoDB] else { return }
        dbProductos = periodoItems
        productos = dbProductos.compactMap( {Producto.parseProductoDB($0) })
    }
}

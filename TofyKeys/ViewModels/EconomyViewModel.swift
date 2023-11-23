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
    @Published var periodos: [ProductoDB] = []
    @Published var productos: [Producto] = []
    
    init(managedObjectContext: NSManagedObjectContext) {
        periodoController = NSFetchedResultsController(fetchRequest: ProductoDB.productoDBFetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        super.init()
        periodoController.delegate = self
        do {
            try periodoController.performFetch()
            periodos = periodoController.fetchedObjects ?? []
            productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Producto.parseProductoDB($0) })
            print("Periodos: \(periodos)")
        } catch {
          print("failed to fetch items!")
        }
    }
    
    func getProductos() {
        productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Producto.parseProductoDB($0) })
    }
    
    func addPeriodo(titulo: String, tipo: TipoProducto, valorInicial: String) {
        var transacciones: [Transaccion] = []
        if !valorInicial.isEmpty, let valor = Double(valorInicial) {
            transacciones.append(Transaccion(id: UUID(),
                                             titulo: "Valor inicial",
                                             tipo: valor >= 0 ? "ingreso" : "gasto",
                                             valor: valor,
                                             category: UUID(),
                                             fecha: Date(),
                                             observacion: ""))
        }
        
        PersistenceController.shared.addPeriodoActual(periodo: Producto(id: UUID(),
                                                                       titulo: titulo,
                                                                       fechaInicio: Date(),
                                                                       transacciones: transacciones,
                                                                       tipo: tipo.rawValue,
                                                                       estado: "activo",
                                                                       accion: ""))
    }
    
    func addTransaction(periodo: Producto, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        PersistenceController.shared.addTransactionToPeriodoActual(allPeriodos: periodos,
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
        guard let productoDB = periodos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (productoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == transactionID }).first {
            PersistenceController.shared.deleteTransaction(transaction, periodo: productoDB)
        }
    }
    
    func editTransaction(periodo: Producto, id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        guard let productoDB = periodos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (productoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == id }).first {
            PersistenceController.shared.editTransaction(productoDB, id: id, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion, fecha: fecha)
            // El controller Did change content no salta y por eso hay que hacerlo "manual"
            try? periodoController.performFetch()
            periodos = periodoController.fetchedObjects ?? []
            productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Producto.parseProductoDB($0) })
        }
    }
}

// MARK: PERIODO DB
extension EconomyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did changed")
        guard let periodoItems = controller.fetchedObjects as? [ProductoDB] else { return }
        periodos = periodoItems
        productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Producto.parseProductoDB($0) })
    }
}

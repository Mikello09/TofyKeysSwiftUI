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
    
    private let periodoController: NSFetchedResultsController<PeriodoDB>
    @Published var periodos: [PeriodoDB] = []
    @Published var productos: [Periodo] = []
    
    init(managedObjectContext: NSManagedObjectContext) {
        periodoController = NSFetchedResultsController(fetchRequest: PeriodoDB.periodoDBFetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        super.init()
        periodoController.delegate = self
        do {
            try periodoController.performFetch()
            periodos = periodoController.fetchedObjects ?? []
            productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Periodo.parsePeriodoDB($0) })
            print("Periodos: \(periodos)")
        } catch {
          print("failed to fetch items!")
        }
    }
    
    func getProductos() {
        productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Periodo.parsePeriodoDB($0) })
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
        
        PersistenceController.shared.addPeriodoActual(periodo: Periodo(id: UUID(),
                                                                       titulo: titulo,
                                                                       fechaInicio: Date(),
                                                                       transacciones: transacciones,
                                                                       tipo: tipo.rawValue,
                                                                       estado: "activo",
                                                                       accion: ""))
    }
    
    func addTransaction(periodo: Periodo, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
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
    
    func deletePeriodoTransaction(transactionID: UUID, periodo: Periodo) {
        guard let periodoDB = periodos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (periodoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == transactionID }).first {
            PersistenceController.shared.deleteTransaction(transaction, periodo: periodoDB)
        }
    }
    
    func editTransaction(periodo: Periodo, id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        guard let periodoDB = periodos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (periodoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == id }).first {
            PersistenceController.shared.editTransaction(periodoDB, id: id, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion, fecha: fecha)
            // El controller Did change content no salta y por eso hay que hacerlo "manual"
            try? periodoController.performFetch()
            periodos = periodoController.fetchedObjects ?? []
            productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Periodo.parsePeriodoDB($0) })
        }
    }
}

// MARK: PERIODO DB
extension EconomyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did changed")
        guard let periodoItems = controller.fetchedObjects as? [PeriodoDB] else { return }
        periodos = periodoItems
        productos = periodos.filter({ $0.estado == "activo" }).compactMap( {Periodo.parsePeriodoDB($0) })
    }
}

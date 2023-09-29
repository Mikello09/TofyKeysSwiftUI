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
    var periodos: [PeriodoDB] = []
    @Published var productos: [Periodo] = []
    @Published var periodoActivo: Periodo?
    
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
            productos = periodos.filter({ $0.tipo != TipoProducto.contabilidadManual.rawValue && $0.tipo != TipoProducto.contabilidadMensual.rawValue }).compactMap( {Periodo.parsePeriodoDB($0) })
            if let periodoDBActivo = periodos.filter({ $0.estado == "activo" && ($0.tipo == TipoProducto.contabilidadManual.rawValue || $0.tipo == TipoProducto.contabilidadMensual.rawValue) }).first {
                periodoActivo = Periodo.parsePeriodoDB(periodoDBActivo)
            }
            print("Periodos: \(periodos)")
        } catch {
          print("failed to fetch items!")
        }
    }
    
    func getPeriodoActivo() {
        if let periodoDBActivo = periodos.filter({ $0.estado == "activo" }).first {
            periodoActivo = Periodo.parsePeriodoDB(periodoDBActivo)
        }
    }
    
    func getProductos() {
        productos = periodos.filter({ $0.tipo != TipoProducto.contabilidadManual.rawValue && $0.tipo != TipoProducto.contabilidadMensual.rawValue }).compactMap( {Periodo.parsePeriodoDB($0) })
    }
    
    func closePeriodoActivo() {
        if let periodoDBActivo = periodos.filter({ $0.estado == "activo" }).first {
            PersistenceController.shared.closePeriodo(periodo: periodoDBActivo)
            periodoActivo = nil
        }
    }
    
    func addPeriodo(titulo: String, tipo: TipoProducto, valorInicial: String) {
        var transacciones: [Transaccion] = []
        if !valorInicial.isEmpty, let valor = Double(valorInicial) {
            transacciones.append(Transaccion(id: UUID(),
                                             titulo: "Valor inicial",
                                             tipo: valor >= 0 ? "ingreso" : "gasto",
                                             valor: valor,
                                             category: UUID(),
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
    
    func addTransaction(periodo: Periodo, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String) {
        PersistenceController.shared.addTransactionToPeriodoActual(allPeriodos: periodos,
                                                                   periodo: periodo,
                                                                   transaction: Transaccion(id: UUID(),
                                                                                            titulo: titulo,
                                                                                            tipo: tipo,
                                                                                            valor: valor,
                                                                                            category: category,
                                                                                            observacion: observacion))
    }
    
    func deletePeriodoTransaction(transactionID: UUID, periodo: Periodo) {
        guard let periodoDB = periodos.filter({ $0.id == periodo.id }).first else { return }
        if let transaction = (periodoDB.transacciones?.allObjects as? [TransaccionDB])?.filter({ $0.id == transactionID }).first {
            PersistenceController.shared.deleteTransaction(transaction, periodo: periodoDB)
        }
    }
}

// MARK: PERIODO DB
extension EconomyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did changed")
        guard let periodoItems = controller.fetchedObjects as? [PeriodoDB] else { return }
        periodos = periodoItems
        productos = periodos.filter({ $0.tipo != TipoProducto.contabilidadManual.rawValue && $0.tipo != TipoProducto.contabilidadMensual.rawValue }).compactMap( {Periodo.parsePeriodoDB($0) })
        if let periodoDBActivo = periodos.filter({ $0.estado == "activo" }).first {
            periodoActivo = Periodo.parsePeriodoDB(periodoDBActivo)
        }
        
    }
}

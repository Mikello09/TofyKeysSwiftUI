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
            if let periodoDBActivo = periodos.filter({ $0.estado == "activo" }).first {
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
    
    func addPeriodo(titulo: String, tipo: String) {
        PersistenceController.shared.addPeriodoActual(periodo: Periodo(id: UUID(),
                                                                       titulo: titulo,
                                                                       fechaInicio: Date(),
                                                                       ingresos: [],
                                                                       gastos: [],
                                                                       tipo: tipo,
                                                                       estado: "activo",
                                                                       accion: ""))
    }
    
    func addGasto(titulo: String, tipo: String, valor: Double, category: UUID, observacion: String) {
        if let periodoActivo {
            PersistenceController.shared.addTransactionToPeriodoActual(allPeriodos: periodos,
                                                                       periodo: periodoActivo,
                                                                       transaction: Transaccion(id: UUID(),
                                                                                                titulo: titulo,
                                                                                                tipo: tipo,
                                                                                                valor: valor,
                                                                                                category: category,
                                                                                                observacion: observacion))
        }
    }
}

// MARK: PERIODO DB
extension EconomyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did changed")
        guard let periodoItems = controller.fetchedObjects as? [PeriodoDB] else { return }
        periodos = periodoItems
        if let periodoDBActivo = periodos.filter({ $0.estado == "activo" }).first {
            periodoActivo = Periodo.parsePeriodoDB(periodoDBActivo)
        }
        
    }
}

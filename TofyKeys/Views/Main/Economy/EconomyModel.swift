//
//  EconomyModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 11/6/23.
//

import Foundation
import CoreData
import SwiftUI

enum TipoProducto: String, CaseIterable {
    case contabilidad
    case cuenta
    case presupuesto
    case gastos
    
    func getImage() -> Image {
        switch self {
        case .contabilidad: return Image("contabilidad")
        case .cuenta: return Image("cuenta")
        case .presupuesto: return Image("presupuesto")
        case .gastos: return Image("gastos")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .contabilidad: return "Contabilidad"
        case .cuenta: return "Cuenta"
        case .presupuesto: return "Presupuesto"
        case .gastos: return "Gastos"
        }
    }
    
    func getShortDescription() -> String {
        switch self {
        case .contabilidad: return "¿Operaciones diarias?"
        case .cuenta: return "¿Tienes un objetivo?"
        case .presupuesto: return "¿Dinero organizado?"
        case .gastos: return "¿Gastos durante un tiempo limitado?"
        }
    }
    
    func getExample() -> String {
        switch self {
        case .contabilidad: return "Gastos mensuales de la casa"
        case .cuenta: return "Cuenta de ahorros"
        case .presupuesto: return "Gasto de un dinero extra"
        case .gastos: return "Gastos en viaje"
        }
    }
}

// MARK: PERIODO
struct Producto: Codable, Hashable {
    var id: UUID
    var titulo: String
    var fechaInicio: Date
    var fechaFinal: Date?
    var transacciones: [Transaccion]
    var tipo: String
    var accion: String
    var valorInicial: Double
    
    static func parseProductoDB(_ productoDB: ProductoDB) -> Producto {
        return Producto(id: productoDB.id ?? UUID(),
                        titulo: productoDB.titulo ?? "",
                        fechaInicio: productoDB.fechaInicio ?? Date(),
                        fechaFinal: productoDB.fechaFinal,
                        transacciones: productoDB.transacciones?.allObjects.compactMap({$0 as? TransaccionDB}).compactMap({ Transaccion.parseTransaccionDB($0) }) ?? [],
                        tipo: productoDB.tipo ?? TipoProducto.contabilidad.rawValue,
                        accion: productoDB.accion ?? "",
                        valorInicial: productoDB.valorInicial)
    }

    func getGastos(forDate: Date = Date()) -> Double {
        var gastos: Double = 0
        transacciones.filter({ $0.fecha >= forDate.startOfMonth && $0.fecha <= forDate.endOfMonth }).filter({ $0.tipo == "gasto" }).forEach({ gastos += $0.valor })
        return gastos
    }
    
    func getIngresos(forDate: Date = Date()) -> Double {
        var ingresos: Double = 0
        transacciones.filter({ $0.fecha >= forDate.startOfMonth && $0.fecha <= forDate.endOfMonth }).filter({ $0.tipo == "ingreso" }).forEach({ ingresos += $0.valor })
        return ingresos
    }
    
    func getIngresosGastosDifference(forDate: Date = Date()) -> Double {
        var resultado:Double = 0
        transacciones.filter({ $0.fecha >= forDate.startOfMonth && $0.fecha <= forDate.endOfMonth }).forEach({ resultado += ($0.tipo == "gasto" ? ($0.valor*(-1)) : $0.valor) })
        return valorInicial + resultado
    }
    
    func getCategories(forDate: Date = Date()) -> [CategoriaItem] {
        var categories: [CategoriaItem] = []
        var uniqueCategories: [UUID] = []
        let transaccionesInDate = transacciones.filter({ $0.fecha >= forDate.startOfMonth && $0.fecha <= forDate.endOfMonth })
        for transaction in transaccionesInDate {
            if !uniqueCategories.contains(where: { $0 == transaction.category}) {
                uniqueCategories.append(transaction.category)
            }
        }
        for category in uniqueCategories {
            let categoryTransactions = transaccionesInDate.filter({ $0.category == category })
            var valor: Double = 0
            categoryTransactions.forEach({ valor += ($0.tipo == "gasto" ? ($0.valor*(-1)) : $0.valor) })
            categories.append(CategoriaItem(category: category, 
                                            value: valor,
                                            numericalComparison: valor - mediaValueFor(category),
                                            percentageComparison: 0,
                                            transactions: categoryTransactions.sorted(by: { $0.valor > $1.valor })))
        }
        return categories.sorted(by: { ($0.value < 0 ? ($0.value*(-1)) : $0.value) > ($1.value < 0 ? ($1.value*(-1)) : $1.value) })
    }
    
    func mediaValueFor(_ category: UUID) -> Double {
        let categoryTransactions = transacciones.filter({ $0.category == category }).sorted(by: {$0.fecha < $1.fecha})
        if let firstCategoryTransactions = categoryTransactions.first {
            let firstTransactionDate = firstCategoryTransactions.fecha.startOfMonth
            let months = Calendar.current.dateComponents([.month], from: firstTransactionDate, to: Date()).month ?? 0
            var monthValues: [Double] = []
            for index in 0...months {
                if let monthDate = Calendar.current.date(byAdding: .month, value: index, to: firstTransactionDate) {
                    let monthTransactions = categoryTransactions.filter({ $0.fecha >= monthDate.startOfMonth && $0.fecha <= monthDate.endOfMonth })
                    var valor: Double = 0
                    monthTransactions.forEach({ valor += ($0.tipo == "gasto" ? ($0.valor*(-1)) : $0.valor) })
                    monthValues.append(valor)
                }
            }
            var totalValue: Double = 0
            monthValues.forEach({ totalValue += $0 })
            return totalValue/Double(monthValues.count)
        } else {
            return 0.0
        }
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
    var image: String
    var title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id && lhs.image == rhs.image && lhs.title == rhs.title
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


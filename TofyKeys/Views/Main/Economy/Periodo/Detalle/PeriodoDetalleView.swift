//
//  PeriodoDetalleView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 7/8/23.
//

import SwiftUI
import CoreData

struct PeriodoDetalleView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    var periodo: Periodo
    @State var showingTipo: String = "gasto"
    
    var body: some View {
        VStack {
            Picker(selection: $showingTipo, label: Text("")) {
                Text("Gasto").tag("gasto")
                Text("Ingreso").tag("ingreso")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            if showingTipo == "gasto" {
                List(periodo.gastos, id: \.self) { gasto in
                    TransactionCell(transaction: gasto, category: getCategory(id: gasto.category))
                        .contextMenu {
                            Button {
                                economyViewModel.deletePeriodoTransaction(id: gasto.id)
                            } label: {
                                HStack {
                                    Text("Eliminar")
                                    Spacer()
                                    Image(systemName: "trash.fill")
                                }
                            }
                        }
                }
            } else {
                List(periodo.ingresos, id: \.self) { ingreso in
                    TransactionCell(transaction: ingreso, category: getCategory(id: ingreso.category))
                        .contextMenu {
                            Button {
                                economyViewModel.deletePeriodoTransaction(id: ingreso.id)
                            } label: {
                                HStack {
                                    Text("Eliminar")
                                    Spacer()
                                    Image(systemName: "trash.fill")
                                }
                            }
                        }
                }
            }
        }
        .navigationTitle(periodo.titulo)
    }
    
    func getCategory(id: UUID) -> Category {
        return categoryViewModel.categories.filter({ $0.id == id }).first ?? Category(id: UUID(), image: Image(systemName: "questionmark.circle.fill"), title: "")
    }
}

struct TransactionCell: View {
    
    var transaction: Transaccion
    var category: Category
    
    var body: some View {
        HStack {
            category.image
            VStack {
                Text(transaction.titulo)
                Text(transaction.valor.toCurrency())
            }
            Spacer()
        }
    }
}

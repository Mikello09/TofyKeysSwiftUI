//
//  EstadisticaViewModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 28/3/24.
//

import Foundation
import SwiftUI

struct CategoryToPlot: Hashable, Identifiable {
    var id: UUID
    var title: String
    var selected: Bool = false
    var image: String
    var valor: Double = 0
    var color: Color = Color.random()
}

enum TimeToPlot: CaseIterable {
    case last3Months
    case last6Months
    case lastYear
    
    func title() -> String {
        switch self {
        case .last3Months: return "Last 3 months"
        case .last6Months: return "Last 6 months"
        case .lastYear: return "Last year"
        }
    }
    
    func months() -> Int {
        switch self {
        case .last3Months: return 3
        case .last6Months: return 6
        case .lastYear: return 12
        }
    }
}

enum TimeAccuracy {
    case month
    case year
}

enum ChartType: CaseIterable {
    case bar
    case linear
    
    func title() -> String {
        switch self {
        case .bar: return "Bar"
        case .linear: return "Linear"
        }
    }
    
    func image() -> Image {
        switch self {
        case .bar: return Image(systemName: "chart.bar.fill")
        case .linear: return Image(systemName: "chart.xyaxis.line")
        }
    }
}

struct EstadisticaPlotData: Hashable {
    var date: Date
    var valores: [CategoryToPlot]
}

struct CategoryData {
    var time: Date
    var value: CGFloat
}

class EstadisticaViewModel: ObservableObject {
    
    var categoryViewModel: TransactionCategoryViewModel
    var producto: Producto
    
    @Published var categoriesToSelect: [CategoryToPlot] = []
    @Published var categoriesToPlot: [EstadisticaPlotData] = []
    @Published var monthTransactions: [UUID: [Transaccion]] = [:]
    
    private var timeToPlot: TimeToPlot = .last6Months
    
    init(producto: Producto, categoryViewModel: TransactionCategoryViewModel) {
        self.producto = producto
        self.categoryViewModel = categoryViewModel
    }
    
    func getCategoriesToPlot() {
        // BY DEFAULT -> ingresos y gastos generales, restante mensual
        var categories: [CategoryToPlot] = []
        for categoryID in producto.getAllProductCategoryIDS() {
            let category = categoryViewModel.getCategory(id: categoryID)
            categories.append(CategoryToPlot(id: category.id, title: category.title, image: category.image))
        }
        categoriesToSelect = categories
    }
    
    func categorySelected(selectedCategory: CategoryToPlot, categoryToOverride: CategoryToPlot? = nil) {
        categoriesToSelect = categoriesToSelect.map({ cp in
            var categoryToUpdate = cp
            if categoryToOverride?.id == categoryToUpdate.id { categoryToUpdate.selected = false }
            if categoryToUpdate.id == selectedCategory.id {
                categoryToUpdate.selected.toggle()
            }
            return categoryToUpdate
        })
        getDataToPlot()
    }
    
    func deleteSelectedCategory(categoryToDelete: CategoryToPlot) {
        categoriesToSelect = categoriesToSelect.map({ cp in
            var categoryToUpdate = cp
            if categoryToDelete.id == categoryToUpdate.id {
                categoryToUpdate.selected = false
            }
            return categoryToUpdate
        })
        if categoriesToSelect.filter({ $0.selected }).isEmpty {
            categoriesToPlot = []
        } else {
            getDataToPlot()
        }
    }
    
    func getDataToPlot() {
        var plotData: [EstadisticaPlotData] = []
        for index in (0..<timeToPlot.months()).reversed() {
            if let month = Calendar.current.date(byAdding: .month, value: -index, to: Date()) {
                var categories: [CategoryToPlot] = []
                for category in categoriesToSelect.filter({ $0.selected }) {
                    var categoryToPlot = category
                    let value = producto.getValueForCategory(categoryID: category.id, forDate: month)
                    categoryToPlot.valor = value
                    categories.append(categoryToPlot)
                }
                plotData.append(EstadisticaPlotData(date: month, valores: categories))
            }
        }
        categoriesToPlot = plotData
    }
    
    func getTransactionsForDate(month: String, year: Int, categories: [UUID]) {
        var monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "LLLL"
        guard let monthDate = monthDateFormatter.date(from: month) else { return }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = Calendar.current.component(.month, from: monthDate)
        dateComponents.day = 1
        guard let createdDate = Calendar.current.date(from: dateComponents) else { return }
        
        var monthTransactions: [UUID: [Transaccion]] = [:]
        for category in categories {
            monthTransactions[category] = producto.transacciones.filter({ $0.fecha.startOfMonth >= createdDate.startOfMonth && $0.fecha.endOfMonth <= createdDate.endOfMonth}).filter({ $0.category == category })
        }
        self.monthTransactions = monthTransactions
    }
    
    func setTimeToPlot(_ timeToPlot: TimeToPlot) {
        self.timeToPlot = timeToPlot
        getDataToPlot()
    }
    
}

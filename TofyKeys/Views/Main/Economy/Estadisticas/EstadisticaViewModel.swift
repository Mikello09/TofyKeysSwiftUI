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

enum TimeToPlot {
    case currentMonth
    case last3Months
    case last6Months
    case lastYear
    case last5Years
}

enum TimeAccuracy {
    case month
    case year
}

enum ChartType {
    case bar
    case linear
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
    
    func categorySelected(selectedCategory: CategoryToPlot) {
        categoriesToSelect = categoriesToSelect.map({ cp in
            var categoryToUpdate = cp
            if categoryToUpdate.id == selectedCategory.id {
                categoryToUpdate.selected.toggle()
            }
            return categoryToUpdate
        })
        getDataToPlot()
    }
    
    func getDataToPlot(timeToPlot: TimeToPlot = .last6Months, timeAccuracy: TimeAccuracy = .month) {
        var plotData: [EstadisticaPlotData] = []
        switch timeToPlot {
        case .last6Months:
            for index in (0..<5).reversed() {
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
        default: ()
        }
        categoriesToPlot = plotData
    }
    
}

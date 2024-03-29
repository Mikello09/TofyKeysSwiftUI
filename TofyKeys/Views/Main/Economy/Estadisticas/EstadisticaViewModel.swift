//
//  EstadisticaViewModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 28/3/24.
//

import Foundation
import SwiftUI

struct CategoryToPlot: Hashable {
    var id: UUID
    var title: String
    var selected: Bool = false
    var image: String
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

struct EstadisticaPlotData {
    var plotDates: [Date]
    var values: [Date: [CGFloat]]
}

struct CategoryData {
    var time: Date
    var value: CGFloat
}

class EstadisticaViewModel: ObservableObject {
    
    var categoryViewModel: TransactionCategoryViewModel
    var producto: Producto
    
    @Published var categoriesToPlot: [CategoryToPlot] = []
    
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
        categoriesToPlot = categories
    }
    
    func categorySelected(selectedCategory: CategoryToPlot) {
        categoriesToPlot = categoriesToPlot.map({ cp in
            var categoryToUpdate = cp
            if categoryToUpdate.id == selectedCategory.id {
                categoryToUpdate.selected.toggle()
            }
            return categoryToUpdate
        })
    }
    
    func getDataToPlot(timeToPlot: TimeToPlot = .last6Months, timeAccuracy: TimeAccuracy = .month) {
        
    }
    
}

//
//  CategoryDB.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/8/23.
//

import Foundation
import CoreData
import SwiftUI

struct CategoriaItem: Identifiable {
    var id: UUID = UUID()
    var category: UUID
    var value: Double
    var numericalComparison: Double
    var percentageComparison: Double
    var transactions: [Transaccion]
}

extension PersistenceController {
    
    func saveCategory(id: UUID, title: String, image: String) {
        let newCategory = TransactionCategoryDB(context: container.viewContext)

        newCategory.id = id
        newCategory.title = title
        newCategory.image = image
        
        save()
    }
    
    func deleteCategory(_ categoryToDelete: TransactionCategoryDB) {
        container.viewContext.delete(categoryToDelete)
        save()
    }
    
    func updateCategory(categoryToUpdate: TransactionCategoryDB, newTitle: String, newImage: String) {
        var category = categoryToUpdate
        category.title = newTitle
        category.image = newImage
        save()
    }
    
}

extension TransactionCategoryDB {
    static var transactionDBFetchRequest: NSFetchRequest<TransactionCategoryDB> {
        let request: NSFetchRequest<TransactionCategoryDB> = TransactionCategoryDB.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        return request
    }
    
    func toCategory() -> Category {
        return Category(id: self.id ?? UUID(),
                        image: self.image ?? "",
                        title: self.title ?? "-")
    }
}

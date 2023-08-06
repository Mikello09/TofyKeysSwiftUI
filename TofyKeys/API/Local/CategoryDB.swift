//
//  CategoryDB.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/8/23.
//

import Foundation
import CoreData
import SwiftUI

extension PersistenceController {
    
    func saveCategory(title: String, image: String) {
        let newCategory = TransactionCategoryDB(context: container.viewContext)

        newCategory.id = UUID()
        newCategory.title = title
        newCategory.image = image
        
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
                        image: Image(systemName: self.image ?? ""),
                        title: self.title ?? "")
    }
}

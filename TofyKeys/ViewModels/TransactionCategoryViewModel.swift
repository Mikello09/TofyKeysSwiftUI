//
//  TransactionCategoryViewModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/8/23.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import UIKit

class TransactionCategoryViewModel: NSObject, ObservableObject {
    
    private let categoryController: NSFetchedResultsController<TransactionCategoryDB>
    
    var categoriesDB: [TransactionCategoryDB] = []
    @Published var categories: [Category] = []
    
    init(managedObjectContext: NSManagedObjectContext) {
        categoryController = NSFetchedResultsController(fetchRequest: TransactionCategoryDB.transactionDBFetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        super.init()
        categoryController.delegate = self
        do {
            try categoryController.performFetch()
            categoriesDB = categoryController.fetchedObjects ?? []
            categories = categoriesDB.map({ $0.toCategory() })
        } catch {
          print("failed to fetch items!")
        }
    }
    
    func addCategory(id: UUID, titulo: String, image: String) {
        PersistenceController.shared.saveCategory(id: id, title: titulo, image: image)
    }
    
    func getCategory(id: UUID) -> Category {
        return categories.filter({ $0.id == id }).first ?? Category(id: UUID(), image: "questionmark.circle.fill", title: "-")
    }
    
    func deleteCategory(id: UUID) {
        if let categoryToDelete = categoriesDB.filter({ $0.id == id }).first {
            PersistenceController.shared.deleteCategory(categoryToDelete)
        }
    }
    
    func updateCategory(id: UUID, title: String, image: String) {
        if let categoryToUpdate = categoriesDB.filter({ $0.id == id }).first {
            PersistenceController.shared.updateCategory(categoryToUpdate: categoryToUpdate,
                                                        newTitle: title,
                                                        newImage: image)
        }
    }
    
}

extension TransactionCategoryViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller did changed")
        guard let categoryItems = controller.fetchedObjects as? [TransactionCategoryDB] else { return }
        categoriesDB = categoryItems
        categories = categoriesDB.map({ $0.toCategory() })
    }
}

//
//  PersistenceController.swift
//  TofyKeys
//
//  Created by Mikel on 31/3/22.
//

import Foundation
import CoreData


struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // A test configuration for SwiftUI previews
    static var userPreview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        let user = UserDB(context: controller.container.viewContext)

        return controller
    }()
    
    // An initializer to load Core Data, optionally able
        // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "TofyKeys")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}

// MARK: USER
extension PersistenceController {
    
    func saveUser(email: String, pass: String) {
        let newUser = UserDB(context: container.viewContext)

        newUser.email = email
        newUser.contrasena = pass

        save()
    }
}
    


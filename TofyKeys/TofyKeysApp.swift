//
//  TofyKeysApp.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI


@main
struct TofyKeysApp: App {
    
    // Scene
    @Environment(\.scenePhase) var scenePhase
    
    // Global ViewModels
    @StateObject var userViewModel: UserViewModel
    @StateObject var recordarViewModel: RecordarViewModel
    @StateObject var economyViewModel: EconomyViewModel
    @StateObject var categoryViewModel: TransactionCategoryViewModel
    
    
    // CoreData
    let persistenceController = PersistenceController.shared
    
    init() {
        let managedObjectContext = persistenceController.container.viewContext
        // USER
        let userViewModel = UserViewModel(managedObjectContext: managedObjectContext)
        self._userViewModel = StateObject(wrappedValue: userViewModel)
        // RECORDAR
        self._recordarViewModel = StateObject(wrappedValue: RecordarViewModel())
        // ECONOMY
        let economyViewModel = EconomyViewModel(managedObjectContext: managedObjectContext)
        let categoryViewModel = TransactionCategoryViewModel(managedObjectContext: managedObjectContext)
        self._economyViewModel = StateObject(wrappedValue: economyViewModel)
        self._categoryViewModel = StateObject(wrappedValue: categoryViewModel)
        
        // UI
        
      }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView(userViewModel: userViewModel,
                           recordarViewModel: recordarViewModel,
                           economyViewModel: economyViewModel,
                           categoryViewModel: categoryViewModel)
        }
        .onChange(of: scenePhase) { // App to background
            persistenceController.save()
        }
    }
}

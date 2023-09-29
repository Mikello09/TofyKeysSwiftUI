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
    @StateObject var claveViewModel: ClaveViewModel
    @StateObject var economyViewModel: EconomyViewModel
    @StateObject var categoryViewModel: TransactionCategoryViewModel
    
    // CoreData
    let persistenceController = PersistenceController.shared
    
    init() {
        let managedObjectContext = persistenceController.container.viewContext
        // CLAVE
        let claveViewModel = ClaveViewModel(managedObjectContext: managedObjectContext)
        self._claveViewModel = StateObject(wrappedValue: claveViewModel)
        // USER
        let userViewModel = UserViewModel(managedObjectContext: managedObjectContext, claveViewModel: claveViewModel)
        self._userViewModel = StateObject(wrappedValue: userViewModel)
        // ECONOMY
        let economyViewModel = EconomyViewModel(managedObjectContext: managedObjectContext)
        let categoryViewModel = TransactionCategoryViewModel(managedObjectContext: managedObjectContext)
        self._economyViewModel = StateObject(wrappedValue: economyViewModel)
        self._categoryViewModel = StateObject(wrappedValue: categoryViewModel)
        
        // UI
        UITabBar.appearance().backgroundColor = .white
      }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView(userViewModel: userViewModel,
                           claveViewModel: claveViewModel,
                           economyViewModel: economyViewModel,
                           categoryViewModel: categoryViewModel)
        }
        .onChange(of: scenePhase) { _ in // App to background
            persistenceController.save()
        }
    }
}

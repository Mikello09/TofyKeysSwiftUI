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
        self._economyViewModel = StateObject(wrappedValue: economyViewModel)
      }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView(userViewModel: userViewModel, claveViewModel: claveViewModel, economyViewModel: economyViewModel)
        }
        .onChange(of: scenePhase) { _ in // App to background
            persistenceController.save()
        }
    }
}

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
      }
    
    var body: some Scene {
        WindowGroup {
            LandingView(userViewModel: userViewModel, claveViewModel: claveViewModel)
        }
        .onChange(of: scenePhase) { _ in // App to background
            persistenceController.save()
        }
    }
}

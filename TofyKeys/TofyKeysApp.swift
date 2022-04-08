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
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    
    // CoreData
    let persistenceController = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environmentObject(userViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in // App to background
            persistenceController.save()
        }
    }
}

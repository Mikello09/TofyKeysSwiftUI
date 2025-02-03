//
//  TofySchema.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/2/25.
//

import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Clave.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

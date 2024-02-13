//
//  TofyNavigation.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/3/23.
//

import Foundation
import SwiftUI

struct TofyNavigation<Content: View>: View {
    
    var tabBarVisibility: Bool = true
    
    var content: () -> Content
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.generalBackground.ignoresSafeArea(edges: .all)
                content()
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(Color.generalBackground, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color.generalBackground, for: .tabBar)
//                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbar(tabBarVisibility ? .visible : .hidden, for: .tabBar)
            }
            .navigationTitle("Tofy")
        }
    }
    
}

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
            content()
                .background {
                    Color.generalBackground.ignoresSafeArea(edges: .all)
                }
                .toolbarBackground(Color.generalBackground, for: .navigationBar)
                .toolbarBackground(Color.generalBackground, for: .tabBar)
        }
    }
    
}

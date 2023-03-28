//
//  TofyNavigation.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/3/23.
//

import Foundation
import SwiftUI

struct TofyNavigation<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
        NavigationStack {
            ZStack(content: content)
                .navigationTitle("Tofy")
        }
    }
    
}

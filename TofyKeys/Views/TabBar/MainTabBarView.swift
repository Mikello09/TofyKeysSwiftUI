//
//  MainTabBarView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/3/23.
//

import Foundation
import SwiftUI

struct MainTabBarView: View {
    // ViewModels
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var claveViewModel: ClaveViewModel
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    var body: some View {
        TabView {
            RecordarView(claveViewModel: claveViewModel)
                .tabItem {
                    Label("Recordar", systemImage: "key.fill")
                }
            EconomyLandingView(economyViewModel: economyViewModel, categoryViewModel: categoryViewModel)
                .tabItem {
                    Label("Economy", systemImage: "dollarsign.circle.fill")
                }
        }
    }
}

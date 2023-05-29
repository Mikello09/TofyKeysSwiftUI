//
//  RecordarView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 1/5/23.
//

import Foundation
import SwiftUI

struct RecordarView: View {
    
    @ObservedObject var recordarVM = RecordarViewModel()
    @ObservedObject var claveViewModel: ClaveViewModel
    
    @State var menuItems: [RecordarMenuItem] = []
    
    @State var goToClaves: Bool = false
    @State var goToParking: Bool = false
    @State var goToLista: Bool = false
    
    var body: some View {
        TofyNavigation {
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    VStack {
                        NavigationLink(destination: ClavesLandingView(claveViewModel: claveViewModel)) {
                            RecordarMenuCell(menuItem: .clave)
                        }
                    }
                    HStack(spacing: 24) {
                        NavigationLink(destination: ParkingView(claveViewModel: claveViewModel)) {
                            RecordarMenuCell(menuItem: .aparcamiento)
                        }
                        NavigationLink(destination: NotasView(claveViewModel: claveViewModel)) {
                            RecordarMenuCell(menuItem: .lista)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Para recordar")
        }
        .onAppear() {
            recordarVM.getMenuItems()
        }
        .onReceive(recordarVM.$menuItems) { items in
            self.menuItems = items
        }
    }
    
}

struct RecordarMenuCell: View {
    
    var menuItem: RecordarMenuItem
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.primaryColor)
            VStack(spacing: 8) {
                menuItem.getImage()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                Text(LocalizedStringKey(menuItem.getTitle()))
                    .title(.white)
            }
        }
        .frame(width: 150, height: 150)
    }
    
}

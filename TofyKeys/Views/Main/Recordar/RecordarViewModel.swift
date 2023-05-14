//
//  RecordarViewModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 1/5/23.
//

import Foundation
import SwiftUI

enum RecordarMenuItem {
    case clave
    case aparcamiento
    case lista
    
    func getTitle() -> String {
        switch self {
        case .clave: return "ClaveTitle"
        case .aparcamiento: return "ParkingTitle"
        case .lista: return "ListTitle"
        }
    }
    
    func getImage() -> Image {
        switch self {
        case .clave: return Image(systemName: "key.fill")
        case .aparcamiento: return Image(systemName: "car.fill")
        case .lista: return Image(systemName: "list.clipboard.fill")
        }
    }
}

class RecordarViewModel: ObservableObject {
    
    @Published var menuItems: [RecordarMenuItem] = []
    
    func getMenuItems() {
        menuItems = [.clave, .aparcamiento, .lista]
    }
    
}

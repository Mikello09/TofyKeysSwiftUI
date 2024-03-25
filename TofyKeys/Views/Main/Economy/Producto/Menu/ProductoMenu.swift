//
//  ProductoMenu.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 9/2/24.
//

import SwiftUI

enum ProductoMenuOption: String, CaseIterable, Identifiable {
    
    var id: String { self.rawValue }
    
    case ingreso
    case gasto
    
    func getTitle() -> String {
        switch self {
        case .ingreso: return "Ingreso"
        case .gasto: return "Gasto"
        }
    }
    
    func getImage(showCategoria: Bool = false) -> Image {
        switch self {
        case .ingreso: return Image(systemName: "plus")
        case .gasto: return Image(systemName: "minus")
        }
    }
}

struct ProductoMenu: View {
    
    var option: ProductoMenuOption
    @Binding var showCategories: Bool
    var completion: (() -> Void)
    
    var body: some View {
        VStack {
            Button {
                completion()
            } label: {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 24, height: 24))
                        .fill(.cyan)
                    option.getImage(showCategoria: showCategories)
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 48, height: 48)
            Text(option.getTitle())
                .font(Font.system(size: 14))
        }
    }
}

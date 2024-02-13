//
//  ProductoMenu.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 9/2/24.
//

import SwiftUI

enum ProductoMenuOption: String, CaseIterable, Identifiable {
    
    var id: String { self.rawValue }
    
    case estadistica
    case categorias
    case ingreso
    case gasto
    
    func getTitle(showCategoria: Bool = false) -> String {
        switch self {
        case .estadistica: return "Estadistica"
        case .categorias: return showCategoria ? "Transacciones" : "Categorias"
        case .ingreso: return "Ingreso"
        case .gasto: return "Gasto"
        }
    }
    
    func getImage(showCategoria: Bool = false) -> Image {
        switch self {
        case .estadistica: return Image(systemName: "chart.bar.xaxis")
        case .categorias: return showCategoria ? Image(systemName: "list.bullet") : Image(systemName: "square.3.layers.3d.down.right")
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
            Text(option.getTitle(showCategoria: showCategories))
                .font(Font.system(size: 14))
        }
    }
}

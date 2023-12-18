//
//  EditCategoryView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 5/12/23.
//

import SwiftUI

struct EditCategoryView: View {
    
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var categories: [Category] = []
    @State var symbols: [String: SymbolCategory] = [:]
    
    @State var editingCategories: [Category] = []
    @State var categoryToDelete: Category?
    @State var deleteAlert: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Edita tus categorías")
                .padding()
            if categories.isEmpty {
                Spacer()
                Text("No hay categorías para editar.")
                    .padding()
                Spacer()
            } else {
                ScrollView(.vertical) {
                    ForEach(categories) { category in
                        if editingCategories.contains(where: { $0.id == category.id }) {
                            EditingCategoryCell(symbols: symbols,
                                                category: category) { newTitle, newImage in
                                editingCategories.removeAll(where: { $0.id == category.id })
                                if let newTitle, let newImage {
                                    categoryViewModel.updateCategory(id: category.id,
                                                                     title: newTitle,
                                                                     image: newImage)
                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                VStack {
                                    HStack(spacing: 24) {
                                        Image(systemName: category.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 28, height: 28)
                                        Text(category.title)
                                            .font(Font.system(size: 16, weight: .semibold))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                editingCategories.append(category)
                                            }
                                        } label: {
                                            Text("Edit")
                                                .font(Font.system(size: 13, weight: .semibold))
                                        }
                                        Button(role: .destructive) {
                                            categoryToDelete = category
                                            deleteAlert = true
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                    }
                                }
                                .padding()
                                .frame(height: 56)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 4)
                            }
                            .padding([.leading, .trailing])
                            .padding(.top, 6)
                        }
                    }
                }
            }
        }
        .onAppear {
            symbols = SFSymbolManager.getAllCategoryImages()
        }
        .onReceive(categoryViewModel.$categories) { categories in
            self.categories = categories
        }
        .alert(isPresented: $deleteAlert) {
            Alert(title: Text("¿Estás seguro de borrar la categoría \(categoryToDelete?.title ?? "-")?"),
                  message: Text("Las transacciones asociadas aparecerán con categoría incógnita"),
                  primaryButton: .destructive(Text("Borrar")) {
                if let idToDelete = categoryToDelete?.id {
                    categoryViewModel.deleteCategory(id: idToDelete)
                }
            },
                  secondaryButton: .cancel())
        }
    }
}

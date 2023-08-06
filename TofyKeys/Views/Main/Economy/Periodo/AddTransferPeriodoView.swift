//
//  AddTransferPeriodoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 29/6/23.
//

import SwiftUI

struct AddTransferPeriodoView: View {
    
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var titulo: String = ""
    @State var tipo: String = "gasto"
    @State var valor: String = ""
    @State var category: UUID = UUID()
    @State var observacion: String = ""
    
    @State var addCategory: Bool = false
    
    var onAdd: (String, String, Double, UUID, String) -> Void
    
    @State var categories: [Category] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    Text("Gasto o Ingreso")
                    HStack {
                        Spacer()
                        Button (action: {
                            if !titulo.isEmpty && !valor.isEmpty {
                                onAdd(titulo, tipo, (valor as NSString).doubleValue, category, observacion)
                            }
                        }, label: {
                            TextButton(text: "Guardar")
                        })
                        .padding()
                    }
                }
                TextField("Título", text: $titulo)
                Picker(selection: $tipo, label: Text("¿Que es lo que quieres añadir?")) {
                    Text("Gasto").tag("gasto")
                    Text("Ingreso").tag("ingreso")
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Valor", text: $valor)
                    .keyboardType(.numberPad)
                TextField("Observaciones", text: $observacion)
                HStack {
                    Text("Category")
                    Spacer()
                }
                GeometryReader { proxy in
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            VStack(spacing: 8) {
                                category.image
                                if category.title != "" {
                                    Text(category.title)
                                        .font(Font.system(size: 13, weight: .regular))
                                }
                            }
                            .frame(width: proxy.size.width/5 - 8, height: proxy.size.width/5 - 8)
                            .background(self.category == category.id ? .green : .clear)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray, lineWidth: 2)
                                    
                            )
                            .onTapGesture {
                                if category.title == "" {
                                    addCategory = true
                                } else {
                                    if self.category == category.id {
                                        self.category = UUID()
                                    } else {
                                        self.category = category.id
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $addCategory, content: {
                AddCategoryView(categoryViewModel: categoryViewModel,
                                isShowing: $addCategory)
            })
        }
        .onReceive(categoryViewModel.$categories) { categories in
            var categoriesToAdd = categories
            categoriesToAdd.append(Category(id: UUID(),
                                            image: Image(systemName: "plus.circle.fill"),
                                            title: ""))
            self.categories = categoriesToAdd
        }
        
    }
}

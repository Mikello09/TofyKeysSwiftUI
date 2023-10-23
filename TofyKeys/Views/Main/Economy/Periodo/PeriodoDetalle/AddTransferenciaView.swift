//
//  AddTransferPeriodoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 29/6/23.
//

import SwiftUI

struct AddTransferenciaView: View {
    
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    var transferencia: Transaccion?
    @State var titulo: String = ""
    @State var tipo: String = "gasto"// gasto | ingreso
    @State var valor: String = ""
    @State var category: UUID = UUID()
    @State var observacion: String = ""
    @State var fecha: Date = Date()
    
    @State var addCategory: Bool = false
    
    @FocusState var descripcionFocused: Bool
    @FocusState var valueFocused: Bool
    
    var onAdd: (String, String, Double, UUID, String, Date) -> Void
    
    @State var categories: [Category] = []
    @State var selectedCategory: Category?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    Text(tipo.uppercased())
                    HStack {
                        Spacer()
                        Button (action: {
                            if !titulo.isEmpty && !valor.isEmpty {
                                onAdd(titulo, tipo, (valor as NSString).doubleValue, selectedCategory?.id ?? category, observacion, fecha)
                            }
                        }, label: {
                            TextButton(text: "Guardar")
                        })
                        .padding()
                    }
                }
                TofyTextField(text: $titulo, title: "Descripcion")
                    .submitLabel(.next)
                    .focused($descripcionFocused)
                    .onSubmit { valueFocused = true }
                HStack {
                    TofyTextField(text: $valor, title: Double(0.0).toCurrency())
                        .focused($valueFocused)
                        .keyboardType(.decimalPad)
                        .frame(height: 96)
                    Spacer()
                    Menu {
                        Section {
                            Button {
                                addCategory = true
                            } label: {
                                VStack(spacing: 8){
                                    Image(systemName: "plus.circle")
                                    Text("Create Category")
                                        .font(Font.system(size: 11))
                                }
                            }
                        }
                        Section {
                            ForEach(categories) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    VStack(spacing: 8){
                                        category.image
                                        Text(category.title)
                                            .font(Font.system(size: 11))
                                    }
                                }
                            }
                        }
                    } label: {
                        VStack(spacing: 8){
                            selectedCategory?.image ?? Image(systemName: "plus.circle")
                            Text(selectedCategory?.title ?? "Add Category")
                                .font(Font.system(size: 11))
                        }
                    }
                    .padding()
                }
                HStack {
                    DatePicker(selection: $fecha, in: ...Date.now, displayedComponents: .date) {
                        Text("Fecha")
                    }
                    Spacer()
                }
            }
            .padding()
            .sheet(isPresented: $addCategory, content: {
                AddCategoryView(categoryViewModel: categoryViewModel,
                                isShowing: $addCategory,
                                categoryAdded: categoryAdded)
            })
        }
        .onAppear {
            descripcionFocused = true
        }
        .onReceive(categoryViewModel.$categories) { categories in
            var categoriesToAdd = categories
            self.categories = categoriesToAdd
        }
    }
    
    func categoryAdded(category: Category) {
        selectedCategory = category
    }
}

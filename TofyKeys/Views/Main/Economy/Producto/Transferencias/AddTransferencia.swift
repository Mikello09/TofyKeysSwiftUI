//
//  AddTransferPeriodoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 29/6/23.
//

import SwiftUI

struct AddTransferencia: View {
    
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    var transferencia: Transaccion?
    @State var titulo: String = ""
    @State var tipo: String = "gasto"// gasto | ingreso
    @State var valor: String = ""
    @State var category: UUID = UUID()
    @State var observacion: String = ""
    @State var fecha: Date = Date()
    
    @State var addCategory: Bool = false
    @State var editCategory: Bool = false
    
    @FocusState var descripcionFocused: Bool
    @FocusState var valueFocused: Bool
    
    var onAdd: (String, String, Double, UUID, String, Date) -> Void
    
    @State var categories: [Category] = []
    @State var selectedCategory: Category?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    HStack {
                        Image(systemName: tipo == "gasto" ? "minus.circle.fill" : "plus.circle.fill")
                            .foregroundColor(tipo == "gasto" ? .red : .green)
                        Text(tipo.uppercased())
                            .font(Font.system(size: 17, weight: .bold))
                            .foregroundStyle(tipo == "gasto" ? .red : .green)
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Spacer()
                        Button (action: {
                            if !titulo.isEmpty && !valor.isEmpty {
                                onAdd(titulo, tipo, (valor.replacingOccurrences(of: ",", with: ".") as NSString).doubleValue, selectedCategory?.id ?? category, observacion, fecha)
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
                    TofyTextField(text: $valor, title: "Valor (€)", tipo: tipo)
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
                            Button {
                                editCategory = true
                            } label: {
                                VStack(spacing: 8){
                                    Image(systemName: "pencil")
                                    Text("Edit Category")
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
                                        Image(systemName: category.image)
                                        Text(category.title)
                                            .font(Font.system(size: 11))
                                    }
                                }
                            }
                        }
                    } label: {
                        VStack(spacing: 8){
                            selectedCategory?.image == nil ? Image(systemName: "plus.circle") : Image(systemName: selectedCategory?.image ?? "")
                            Text(selectedCategory?.title ?? "Add Category")
                                .font(Font.system(size: 11))
                        }
                    }
                    .padding()
                }
                HStack {
                    DatePicker(selection: $fecha, in: ...(Calendar.current.date(byAdding: .year, value: 1, to: Date.now)!), displayedComponents: .date) {
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
            .sheet(isPresented: $editCategory) {
                EditCategoryView(categoryViewModel: categoryViewModel)
            }
        }
        .onAppear {
            descripcionFocused = true
        }
        .onReceive(categoryViewModel.$categories) { categories in
            self.categories = categories
        }
    }
    
    func categoryAdded(category: Category) {
        selectedCategory = category
    }
}

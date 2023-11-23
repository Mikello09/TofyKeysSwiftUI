//
//  TransferDetailView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 16/10/23.
//

import SwiftUI

struct TransferDetailView: View {
    
    enum TextFields: Hashable {
        case titulo
        case valor
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    @FocusState private var focused: TextFields?
    
    var transfer: Transaccion
    var onEdit: (UUID, String, String, Double, UUID, String, Date) -> Void
    var onDelete: (Transaccion) -> Void
    
    @State var titulo: String = ""
    @State var tipo: String = "gasto"// gasto | ingreso
    @State var valor: String = ""
    @State var category: UUID = UUID()
    @State var observacion: String = ""
    @State var fecha: Date = Date()
    
    @State var addCategory: Bool = false
    
    @State var categories: [Category] = []
    @State var selectedCategory: Category?
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                TofyTextField(text: $titulo, title: "Descripcion")
                    .keyboardType(.default)
                    .focused($focused, equals: .titulo)
                    .frame(height: 96)
                VStack{
                    HStack {
                        ZStack {
                            Circle()
                                .fill(tipo == "ingreso" ? .green : .clear)
                                .frame(width: 20, height: 20)
                                .padding()
                            Circle()
                                .stroke(tipo == "ingreso" ? Color.green : Color.primaryColor, lineWidth: tipo == "ingreso" ? 4 : 2)
                                .frame(width: 28, height: 28)
                        }
                        Text("Ingreso")
                        Spacer()
                    }
                    .frame(height: 48)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(tipo == "ingreso" ? Color.green.opacity(0.3) : Color.clear)
                    })
                    .onTapGesture {
                        tipo = "ingreso"
                    }
                    HStack {
                        ZStack {
                            Circle()
                                .fill(tipo == "gasto" ? .red : .clear)
                                .frame(width: 20, height: 20)
                                .padding()
                            Circle()
                                .stroke(tipo == "gasto" ? Color.red : Color.primaryColor, lineWidth: tipo == "gasto" ? 4 : 2)
                                .frame(width: 28, height: 28)
                        }
                        Text("Gasto")
                        Spacer()
                    }
                    .frame(height: 48)
                    .onTapGesture {
                        tipo = "gasto"
                    }
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(tipo == "gasto" ? Color.red.opacity(0.3) : Color.clear)
                    })
                }
                HStack {
                    TofyTextField(text: $valor, title: Double(0.0).toCurrency())
                        .keyboardType(.decimalPad)
                        .focused($focused, equals: .valor)
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
                                    self.category = category.id
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
                HStack {
                    Button(role: .destructive) {
                        onDelete(transfer)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Spacer()
                }
                Spacer()
                Button {
                    onEdit(transfer.id, titulo, tipo, (valor as NSString).doubleValue, selectedCategory?.id ?? category, observacion, fecha)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(canSaveChanges() ? Color.green : Color.gray)
                        Text("Save changes")
                            .foregroundStyle(Color.blackTofy)
                            .font(Font.system(size: 16, weight: .semibold))
                    }
                }
                .disabled(!canSaveChanges())
                .frame(height: 56)

            }
        }
        .padding([.leading, .trailing, .bottom])
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        focused = nil
                    }
                }
            }
        }
        .sheet(isPresented: $addCategory, content: {
            AddCategoryView(categoryViewModel: categoryViewModel,
                            isShowing: $addCategory,
                            categoryAdded: categoryAdded)
        })
        .onAppear {
            titulo = transfer.titulo
            valor = "\(transfer.valor)"
            tipo = transfer.tipo
            fecha = transfer.fecha
            category = transfer.category
            selectedCategory = categoryViewModel.getCategory(id: transfer.category)
        }
        .onReceive(categoryViewModel.$categories) { categories in
            self.categories = categories
        }
    }
    
    func canSaveChanges() -> Bool {
        return titulo != transfer.titulo || tipo != transfer.tipo || category != transfer.category || (valor as NSString).doubleValue != transfer.valor || fecha != transfer.fecha
    }
    
    func categoryAdded(category: Category) {
        selectedCategory = category
        self.category = category.id
    }
    
}

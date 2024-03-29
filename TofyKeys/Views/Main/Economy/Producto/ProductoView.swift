//
//  PeriodoDetalleView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 7/8/23.
//

import SwiftUI
import CoreData

struct ProductoView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var producto: Producto
    @State var transacciones: [Transaccion] = []
    @State var actualMonth: Date = Date()
    
    @State var showCategories: Bool = false
    @State var addGasto: Bool = false
    @State var addIngreso: Bool = false
    @State var detailedCategories: [Category] = []
    
    var body: some View {
        TofyNavigation(tabBarVisibility: false) {
            ZStack {
                VStack(spacing: 0) {
                    switch producto.tipo {
                    case TipoProducto.contabilidad.rawValue:
                        HStack {
                            VStack(alignment: .leading) {
                                let difference = producto.getIngresosGastosDifference(forDate: actualMonth)
                                Text("Disponible")
                                    .font(Font.system(size: 10, weight: .semibold))
                                Text(difference.toCurrency())
                                    .font(Font.system(size: 32, weight: .bold))
                                    .foregroundStyle(difference.resultColor())
                            }
                            Spacer()
                            VStack {
                                HStack {
                                    Button(action: {
                                        actualMonth = Calendar.current.date(byAdding: .month, value: -1, to: actualMonth) ?? Date()
                                        economyViewModel.getTransacciones(producto: producto, forDate: actualMonth)
                                    }, label: {
                                        Image(systemName: "chevron.left")
                                    })
                                    VStack {
                                        Text(actualMonth.getMonthTitle())
                                            .font(Font.system(size: 16, weight: .semibold))
                                    }
                                    Button(action: {
                                        actualMonth = Calendar.current.date(byAdding: .month, value: 1, to: actualMonth) ?? Date()
                                        economyViewModel.getTransacciones(producto: producto, forDate: actualMonth)
                                    }, label: {
                                        Image(systemName: "chevron.right")
                                    })
                                }
                                Text(actualMonth.getYear())
                                    .font(Font.system(size: 10, weight: .semibold))
                            }
                        }
                        .padding([.leading, .trailing, .top])
                    default: EmptyView()
                    }
                    GeometryReader { proxy in
                        VStack {
                            HStack(spacing: 0) {
                                NavigationLink {
                                    Estadisticas(producto: producto, categoryViewModel: categoryViewModel)
                                } label: {
                                    ZStack {
                                        Color.cyan
                                        Text("Estadísticas")
                                            .font(Font.system(size: 16, weight: .semibold))
                                            .foregroundStyle(Color.white)
                                    }
                                    .frame(height: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .padding()
                                Spacer()
                                ForEach(ProductoMenuOption.allCases) { option in
                                    ProductoMenu(option: option, showCategories: $showCategories) {
                                        switch option {
                                        case .gasto: addGasto = true
                                        case.ingreso: addIngreso = true
                                        }
                                    }
                                    .frame(width: proxy.size.width/4)
                                }
                            }
                            .frame(height: 84)
                            if transacciones.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("No hay movimientos")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Spacer()
                                }
                            } else {
                                ScrollView(.vertical) {
                                    VStack(spacing: 4) {
                                        VStack {
                                            Picker("", selection: $showCategories) {
                                                Text("Transacciones").tag(false)
                                                Text("Categorías").tag(true)
                                            }
                                            .pickerStyle(.segmented)
                                            .padding()
                                            ZStack {
                                                Color.white
                                                VStack {
                                                    if !showCategories {
                                                        ForEach(transacciones.sorted(by: { $0.fecha > $1.fecha })) { transaccion in
                                                            VStack(spacing: 0) {
                                                                NavigationLink {
                                                                    TransferDetail(categoryViewModel: categoryViewModel,
                                                                                       transfer: transaccion,
                                                                                       onEdit: onEdit,
                                                                                       onDelete: onDelete)
                                                                } label: {
                                                                    TransactionCell(transaction: transaccion, category: categoryViewModel.getCategory(id: transaccion.category))
                                                                        .padding()
                                                                }
                                                                Divider()
                                                                    .padding(.leading)
                                                            }
                                                            .contextMenu {
                                                                Button {
                                                                    economyViewModel.deletePeriodoTransaction(transactionID: transaccion.id, periodo: producto)
                                                                } label: {
                                                                    HStack {
                                                                        Text("Eliminar")
                                                                        Spacer()
                                                                        Image(systemName: "trash.fill")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        ForEach(producto.getCategories(forDate: actualMonth)) { categoryItem in
                                                            VStack(spacing: 0) {
                                                                let category = categoryViewModel.getCategory(id: categoryItem.category)
                                                                CategoryCell(item: categoryItem, category: category, detailedCategories: $detailedCategories)
                                                                    .padding()
                                                                Divider()
                                                                    .padding(.leading)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .padding([.leading, .trailing])
                                        }
                                    }
                                }
                                .coordinateSpace(name: "scroll")
                            }
                        }
                    }
                }
            }
            .navigationTitle(producto.titulo)
            .toolbar(.hidden, for: .tabBar)
        }
        .sheet(isPresented: $addGasto, content: {
            AddTransferencia(categoryViewModel: categoryViewModel,
                                 tipo: "gasto",
                                 fecha: actualMonth.startOfMonth == Date().startOfMonth ? Date() : actualMonth.startOfMonth,
                                 onAdd: onAdd)
        })
        .sheet(isPresented: $addIngreso) {
            AddTransferencia(categoryViewModel: categoryViewModel,
                                 tipo: "ingreso",
                                 fecha: actualMonth.startOfMonth == Date().startOfMonth ? Date() : actualMonth.startOfMonth,
                                 onAdd: onAdd)
        }
        .onAppear {
            economyViewModel.getTransacciones(producto: producto, forDate: Date())
        }
        .onReceive(economyViewModel.$dbProductos, perform: { periodos in
            if let detalle = periodos.filter({ $0.id == producto.id }).first {
                producto = Producto.parseProductoDB(detalle)
                economyViewModel.getTransacciones(producto: producto, forDate: actualMonth)
            }
        })
        .onReceive(economyViewModel.$transaciones, perform: { transacciones in
            self.transacciones = transacciones
        })
    }
    
    func onAdd(titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        economyViewModel.addTransaction(periodo: producto,
                                        titulo: titulo,
                                        tipo: tipo,
                                        valor: valor,
                                        category: category,
                                        observacion: observacion,
                                        fecha: fecha)
        addGasto = false
        addIngreso = false
    }
    
    func onEdit(id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        economyViewModel.editTransaction(periodo: producto, id: id, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion, fecha: fecha)
    }
    
    func onDelete(transaccion: Transaccion) {
        economyViewModel.deletePeriodoTransaction(transactionID: transaccion.id, periodo: producto)
    }
}

// MARK: TRANSACTION CELL
struct TransactionCell: View {
    
    var transaction: Transaccion
    var category: Category
    
    var body: some View {
        HStack {
            Image(systemName: category.image)
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.black)
                .frame(width: 32, height: 32)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 8)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(transaction.titulo)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.primaryColor)
                    Text(transaction.fecha.toDayString())
                        .font(Font.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.secondaryColor)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    Text(transaction.valor.toCurrency())
                        .font(Font.system(size: 14, weight: .semibold))
                        .foregroundStyle(transaction.tipo == "ingreso" ? .green : .red)
                    Text(category.title)
                        .font(Font.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.secondaryColor)
                }
            }
            Spacer()
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
